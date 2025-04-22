from __future__ import annotations
import logging
from typing import Optional

from homeassistant.config_entries import ConfigEntry
from homeassistant.core import HomeAssistant
from homeassistant.components import persistent_notification
from homeassistant.helpers import device_registry, entity_registry

from .miot.miot_storage import (
    DeviceManufacturer, MIoTStorage, MIoTCert)
from .miot.miot_spec import (
    MIoTSpecInstance, MIoTSpecParser, MIoTSpecService)
from .miot.const import (
    DEFAULT_INTEGRATION_LANGUAGE, DOMAIN, SUPPORTED_PLATFORMS)
from .miot.miot_error import MIoTOauthError
from .miot.miot_device import MIoTDevice
from .miot.miot_client import MIoTClient, get_miot_instance_async

_LOGGER = logging.getLogger(__name__)


async def async_setup(hass: HomeAssistant, hass_config: dict) -> bool:
    # pylint: disable=unused-argument
    hass.data.setdefault(DOMAIN, {})
    # {[entry_id:str]: MIoTClient}, miot client instance
    hass.data[DOMAIN].setdefault('miot_clients', {})
    # {[entry_id:str]: list[MIoTDevice]}
    hass.data[DOMAIN].setdefault('devices', {})
    # {[entry_id:str]: entities}
    hass.data[DOMAIN].setdefault('entities', {})
    for platform in SUPPORTED_PLATFORMS:
        hass.data[DOMAIN]['entities'][platform] = []
    return True


async def async_setup_entry(
    hass: HomeAssistant, config_entry: ConfigEntry
) -> bool:
    """Set up an entry."""
    def ha_persistent_notify(
        notify_id: str, title: Optional[str] = None,
        message: Optional[str] = None
    ) -> None:
        """Send messages in Notifications dialog box."""
        if title:
            persistent_notification.async_create(
                hass=hass,  message=message,
                title=title, notification_id=notify_id)
        else:
            persistent_notification.async_dismiss(
                hass=hass, notification_id=notify_id)

    entry_id = config_entry.entry_id
    entry_data = dict(config_entry.data)

    ha_persistent_notify(
        notify_id=f'{entry_id}.oauth_error', title=None, message=None)

    try:
        miot_client: MIoTClient = await get_miot_instance_async(
            hass=hass, entry_id=entry_id,
            entry_data=entry_data,
            persistent_notify=ha_persistent_notify)
        # Spec parser
        spec_parser = MIoTSpecParser(
            lang=entry_data.get(
                'integration_language', DEFAULT_INTEGRATION_LANGUAGE),
            storage=miot_client.miot_storage,
            loop=miot_client.main_loop
        )
        await spec_parser.init_async()
        # Manufacturer
        manufacturer: DeviceManufacturer = DeviceManufacturer(
            storage=miot_client.miot_storage,
            loop=miot_client.main_loop)
        await manufacturer.init_async()
        miot_devices: list[MIoTDevice] = []
        er = entity_registry.async_get(hass=hass)
        for did, info in miot_client.device_list.items():
            spec_instance: MIoTSpecInstance = await spec_parser.parse(
                urn=info['urn'])
            if spec_instance is None:
                _LOGGER.error('spec content is None, %s, %s', did, info)
                continue
            device: MIoTDevice = MIoTDevice(
                miot_client=miot_client,
                device_info={
                    **info, 'manufacturer': manufacturer.get_name(
                        info.get('manufacturer', ''))},
                spec_instance=spec_instance)
            miot_devices.append(device)
            device.spec_transform()
            # Remove filter entities and non-standard entities
            for platform in SUPPORTED_PLATFORMS:
                # ONLY support filter spec service translate entity
                if platform in device.entity_list:
                    filter_entities = list(filter(
                        lambda entity: (
                            isinstance(entity.spec, MIoTSpecService)
                            and (
                                entity.spec.need_filter
                                or (
                                    miot_client.hide_non_standard_entities
                                    and entity.spec.proprietary))
                        ),
                        device.entity_list[platform]))
                    for entity in filter_entities:
                        device.entity_list[platform].remove(entity)
                        entity_id = device.gen_service_entity_id(
                            ha_domain=platform, siid=entity.spec.iid)
                        if er.async_get(entity_id_or_uuid=entity_id):
                            er.async_remove(entity_id=entity_id)
                if platform in device.prop_list:
                    filter_props = list(filter(
                        lambda prop: (
                            prop.need_filter or (
                                miot_client.hide_non_standard_entities
                                and prop.proprietary)),
                        device.prop_list[platform]))
                    for prop in filter_props:
                        device.prop_list[platform].remove(prop)
                        entity_id = device.gen_prop_entity_id(
                            ha_domain=platform, spec_name=prop.name,
                            siid=prop.service.iid, piid=prop.iid)
                        if er.async_get(entity_id_or_uuid=entity_id):
                            er.async_remove(entity_id=entity_id)
                if platform in device.event_list:
                    filter_events = list(filter(
                        lambda event: (
                            event.need_filter or (
                                miot_client.hide_non_standard_entities
                                and event.proprietary)),
                        device.event_list[platform]))
                    for event in filter_events:
                        device.event_list[platform].remove(event)
                        entity_id = device.gen_event_entity_id(
                            ha_domain=platform, spec_name=event.name,
                            siid=event.service.iid, eiid=event.iid)
                        if er.async_get(entity_id_or_uuid=entity_id):
                            er.async_remove(entity_id=entity_id)
                if platform in device.action_list:
                    filter_actions = list(filter(
                        lambda action: (
                            action.need_filter or (
                                miot_client.hide_non_standard_entities
                                and action.proprietary)),
                        device.action_list[platform]))
                    for action in filter_actions:
                        device.action_list[platform].remove(action)
                        entity_id = device.gen_action_entity_id(
                            ha_domain=platform, spec_name=action.name,
                            siid=action.service.iid, aiid=action.iid)
                        if er.async_get(entity_id_or_uuid=entity_id):
                            er.async_remove(entity_id=entity_id)
                        # Remove non-standard action debug entity
                        if platform == 'notify':
                            entity_id = device.gen_action_entity_id(
                                ha_domain='text', spec_name=action.name,
                                siid=action.service.iid, aiid=action.iid)
                            if er.async_get(entity_id_or_uuid=entity_id):
                                er.async_remove(entity_id=entity_id)
            # Action debug
            if miot_client.action_debug:
                if 'notify' in device.action_list:
                    # Add text entity for debug action
                    device.action_list['action_text'] = (
                        device.action_list['notify'])
            else:
                # Remove text entity for debug action
                for action in device.action_list.get('notify', []):
                    entity_id = device.gen_action_entity_id(
                        ha_domain='text', spec_name=action.name,
                        siid=action.service.iid, aiid=action.iid)
                    if er.async_get(entity_id_or_uuid=entity_id):
                        er.async_remove(entity_id=entity_id)

        hass.data[DOMAIN]['devices'][config_entry.entry_id] = miot_devices
        await hass.config_entries.async_forward_entry_setups(
            config_entry, SUPPORTED_PLATFORMS)

        # Remove the deleted devices
        devices_remove = (await miot_client.miot_storage.load_user_config_async(
            uid=config_entry.data['uid'],
            cloud_server=config_entry.data['cloud_server'],
            keys=['devices_remove'])).get('devices_remove', [])
        if isinstance(devices_remove, list) and devices_remove:
            dr = device_registry.async_get(hass)
            for did in devices_remove:
                device_entry = dr.async_get_device(
                    identifiers={(
                        DOMAIN,
                        MIoTDevice.gen_did_tag(
                            cloud_server=config_entry.data['cloud_server'],
                            did=did))},
                    connections=None)
                if not device_entry:
                    _LOGGER.error('remove device not found, %s', did)
                    continue
                dr.async_remove_device(device_id=device_entry.id)
                _LOGGER.info(
                    'delete device entry, %s, %s', did, device_entry.id)
            await miot_client.miot_storage.update_user_config_async(
                uid=config_entry.data['uid'],
                cloud_server=config_entry.data['cloud_server'],
                config={'devices_remove': []})

        await spec_parser.deinit_async()
        await manufacturer.deinit_async()

    except MIoTOauthError as oauth_error:
        ha_persistent_notify(
            notify_id=f'{entry_id}.oauth_error',
            title='Xiaomi Home Oauth Error',
            message=f'Please re-add.\r\nerror: {oauth_error}'
        )
    except Exception as err:
        raise err

    return True


async def async_unload_entry(
    hass: HomeAssistant, config_entry: ConfigEntry
) -> bool:
    """Unload the entry."""
    entry_id = config_entry.entry_id
    # Unload the platform
    unload_ok = await hass.config_entries.async_unload_platforms(
        config_entry, SUPPORTED_PLATFORMS)
    if unload_ok:
        hass.data[DOMAIN]['entities'].pop(entry_id, None)
        hass.data[DOMAIN]['devices'].pop(entry_id, None)
    # Remove integration data
    miot_client: MIoTClient = hass.data[DOMAIN]['miot_clients'].pop(
        entry_id, None)
    if miot_client:
        await miot_client.deinit_async()
    del miot_client
    return True


async def async_remove_entry(
    hass: HomeAssistant, config_entry: ConfigEntry
) -> bool:
    """Remove the entry."""
    entry_data = dict(config_entry.data)
    uid: str = entry_data['uid']
    cloud_server: str = entry_data['cloud_server']
    miot_storage: MIoTStorage = hass.data[DOMAIN]['miot_storage']
    miot_cert: MIoTCert = MIoTCert(
        storage=miot_storage, uid=uid, cloud_server=cloud_server)

    # Clean device list
    await miot_storage.remove_async(
        domain='miot_devices', name=f'{uid}_{cloud_server}', type_=dict)
    # Clean user configuration
    await miot_storage.update_user_config_async(
        uid=uid, cloud_server=cloud_server, config=None)
    # Clean cert file
    await miot_cert.remove_user_cert_async()
    await miot_cert.remove_user_key_async()
    return True
