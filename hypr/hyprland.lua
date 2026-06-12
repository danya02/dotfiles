-- Hyprland Lua config - main entry point
-- Refer to the wiki for more information:
-- https://wiki.hypr.land/Configuring/Start/
--
-- Configuration is split into modules under the modules/ subdirectory.
-- Each module is wrapped in pcall so a syntax error in one file won't
-- prevent the rest from loading (emergency binds will still work).

local modules = {
    "modules.environment",
    "monitors",
    "modules.appearance",
    "modules.input",
    "modules.rules",
    "modules.keybinds",
    "modules.autostart",
}

for _, mod in ipairs(modules) do
    local ok, err = pcall(require, mod)
    if not ok then
        hl.notification.create({
            text    = "Config error in '" .. mod .. "': " .. tostring(err),
            timeout = 10000,
            icon    = "error",
        })
    end
end
