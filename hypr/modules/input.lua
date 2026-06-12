-- modules/input.lua
-- Keyboard, mouse, touchpad, and gesture settings.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_variant = "",
        kb_model   = "",
        -- alt+shift to toggle between us and ru layouts
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,

        -- -1.0 to 1.0, 0 means no modification
        sensitivity = 0.12,

        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
            scroll_factor  = 1.5,
        },
    },
})

-- 3-finger horizontal swipe to switch workspaces
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Per-device config example (uncomment and edit as needed):
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })
