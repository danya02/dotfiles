-- modules/rules.lua
-- Window rules, workspace rules, and layer rules.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-----------------------------
---- GLOBAL WINDOW RULES ----
-----------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with XWayland windows that have no class/title
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Hyprland-run helper: float and position at the bottom of the screen
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-------------------------------
---- SMART GAPS (no border) ----
-------------------------------
-- Remove gaps/rounding when only one tiled window is visible, or when
-- a window is maximised. Mirrors the workspace rules in your old .conf.
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#smart-gaps

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name        = "no-borders-single-tiled",
    match       = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name        = "no-borders-maximised",
    match       = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

------------------------------------
---- APP → WORKSPACE ASSIGNMENTS ----
------------------------------------
-- Uncomment any of these to pin apps to specific workspaces.
-- Pair with the corresponding exec_cmd call in autostart.lua.

-- hl.window_rule({ match = { class = "^firefox$"            }, workspace = "2" })
-- hl.window_rule({ match = { class = "^Spotify$"            }, workspace = "7" })
-- hl.window_rule({ match = { class = "^steam$"              }, workspace = "8" })
-- hl.window_rule({ match = { class = "^discord$"            }, workspace = "9" })
-- hl.window_rule({ match = { class = "^org.telegram.desktop$" }, workspace = "9" })
-- hl.window_rule({ match = { class = "^thunderbird$"        }, workspace = "10" })
