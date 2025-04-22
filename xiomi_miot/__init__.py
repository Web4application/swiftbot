from homeassistant import config_entries
from homeassistant.core import callback
import voluptuous as vol

from .const import DOMAIN, CONF_HOST, CONF_TOKEN, DEFAULT_NAME, DEFAULT_POLLING_INTERVAL

class XiaomiConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    """Handle a config flow for Xiaomi integration."""

    VERSION = 1

    async def async_step_user(self, user_input=None):
        """Handle the initial step."""
        errors = {}

        if user_input is not None:
            # Validate the user input
            valid = await self._validate_input(user_input)
            if valid:
                return self.async_create_entry(title="Xiaomi Device", data=user_input)
            else:
                errors["base"] = "invalid_credentials"

        # Device discovery (placeholder for actual implementation)
        discovered_devices = await self._discover_devices()
        if discovered_devices:
            # Provide a list of discovered devices for selection
            return self.async_show_form(
                step_id="select_device",
                data_schema=vol.Schema({
                    vol.Required("device"): vol.In(discovered_devices)
                }),
                errors=errors
            )

        # Define the schema for user input
        data_schema = vol.Schema({
            vol.Required(CONF_HOST): str,
            vol.Required(CONF_TOKEN): str,
        })

        return self.async_show_form(
            step_id="user", data_schema=data_schema, errors=errors
        )

    async def async_step_select_device(self, user_input=None):
        """Handle device selection step."""
        if user_input is not None:
            return self.async_create_entry(title="Xiaomi Device", data=user_input)

        return self.async_abort(reason="no_devices_found")

    async def _validate_input(self, data):
        """Validate the user input."""
        try:
            host = data[CONF_HOST]
            token = data[CONF_TOKEN]
            # Simulate a connection to the Xiaomi device (add actual validation here)
            return True
        except Exception as e:
            # Log detailed errors for troubleshooting
            self.logger.error(f"Validation failed: {e}")
            return False

    async def _discover_devices(self):
        """Discover Xiaomi devices on the network."""
        # Simulate discovery logic (replace with actual network scanning)
        return ["Device 1", "Device 2", "Device 3"]

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
            vol.Optional("option_1", default=True): bool,
            vol.Optional("polling_interval", default=DEFAULT_POLLING_INTERVAL): int,
            vol.Optional("platforms", default=["light", "sensor", "switch"]): vol.All(list, [str]),
        })

        return self.async_show_form(step_id="init", data_schema=options_schema)
