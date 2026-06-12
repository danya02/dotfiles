-- modules/monitors.lua
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- HDMI mode: set hdmi_mirror to true to mirror eDP-1, false to extend.
-- Set hdmi_enabled to false to ignore the external port entirely.

local hdmi_enabled = true   -- set false if you have no external monitor
local hdmi_mirror  = true   -- true = mirror eDP-1 | false = extend (to the right)

-- Laptop screen
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- External monitor
if hdmi_enabled then
    if hdmi_mirror then
        hl.monitor({
            output   = "HDMI-A-1",
            mode     = "preferred",
            position = "auto",
            scale    = 1,
            mirror   = "eDP-1",
        })
    else
        -- Extend: HDMI sits to the right of the laptop screen.
        -- Adjust position if your physical layout differs.
        hl.monitor({
            output   = "HDMI-A-1",
            mode     = "preferred",
            position = "1920x0",
            scale    = 1,
        })
    end
end
