from homeassistant import config_entries
from homeassistant.core import callback
import voluptuous as vol
import logging

from .const import DOMAIN, CONF_HOST, CONF_TOKEN, DEFAULT_POLLING_INTERVAL

_LOGGER = logging.getLogger(__name__)

class XiaomiConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    """Handle a config flow for Xiaomi integration."""

    VERSION = 1

    async def async_step_user(self, user_input=None):
        """Handle the initial step."""
        errors = {}

        if user_input is not None:
            # Validate the user input
            valid, error_message = await self._validate_input(user_input)
            if valid:
                return self.async_create_entry(title="Xiaomi Device", data=user_input)
            else:
                errors["base"] = error_message

        # Provide tooltips and pre-filled defaults
        data_schema = vol.Schema({
            vol.Required(CONF_HOST, description="Enter the device host address"): str,
            vol.Required(CONF_TOKEN, description="Enter the authentication token"): str,
        })

        return self.async_show_form(
            step_id="user", data_schema=data_schema, errors=errors
        )

    async def _validate_input(self, data):
        """Validate the user input."""
        try:
            host = data[CONF_HOST]
            token = data[CONF_TOKEN]
            # Simulate validation logic (add actual device connection logic)
            if not host or not token:
                raise ValueError("Host or token is missing.")
            return True, None
        except Exception as ex:
            _LOGGER.error(f"Validation failed: {ex}")
            return False, "invalid_credentials"

    async def async_step_discovery(self, user_input=None):
        """Discover Xiaomi devices."""
        errors = {}
        discovered_devices = await self._discover_devices()
        if not discovered_devices:
            errors["base"] = "no_devices_found"
            return self.async_abort(reason="no_devices_found")

        if user_input is not None:
            # Handle device selection
            return self.async_create_entry(title=user_input["device"], data=user_input)

        data_schema = vol.Schema({
            vol.Required("device", description="Select a device"): vol.In(discovered_devices)
        })

        return self.async_show_form(step_id="discovery", data_schema=data_schema, errors=errors)

    async def _discover_devices(self):
        """Discover Xiaomi devices on the network."""
        # Simulated device discovery (replace with actual implementation)
        return ["Xiaomi Device 1", "Xiaomi Device 2", "Xiaomi Device 3"]

    @staticmethod
    @callback
    def async_get_options_flow(config_entry):
        """Return the options flow handler."""
        return XiaomiOptionsFlowHandler(config_entry)


class XiaomiOptionsFlowHandler(config_entries.OptionsFlow):
    """Handle options for Xiaomi integration."""

    def __init__(self, config_entry):
        self.config_entry = config_entry

    async def async_step_init(self, user_input=None):
        """Manage the options."""
        if user_input is not None:
            return self.async_create_entry(title="", data=user_input)

        options_schema = vol.Schema({
            vol.Optional("polling_interval", default=DEFAULT_POLLING_INTERVAL): int,
            vol.Optional("language", default="en"): str,
        })

        return self.async_show_form(step_id="init", data_schema=options_schema)
