-- modules/keybinds.lua
-- All keyboard and mouse bindings.
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
-- See https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local mainMod = "SUPER"

-- Programs (keep in sync with autostart.lua)
local terminal    = "kitty"
local browser     = "firefox"
local fileManager = "thunar"
local menu        = "wofi --show drun --insensitive"

------------------------------
---- APPLICATION LAUNCHERS ----
------------------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(menu))

-- Clipboard history (requires cliphist + wofi + wl-copy)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(
    [[cliphist list | xargs -d "\n" printf "%q\n" | wofi --insensitive --dmenu | xargs -0 -I {} bash -c "echo {}" | cliphist decode | wl-copy]]
))

-----------------------------
---- WINDOW MANAGEMENT ----
-----------------------------

hl.bind(mainMod .. " + X",            hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q",    hl.dsp.exit())
hl.bind(mainMod .. " + space",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W",            hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())
hl.bind(mainMod .. " + E",            hl.dsp.layout("togglesplit"))  -- dwindle only

-- Cycle windows in floating workspace and bring focused to front
hl.bind(mainMod .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

---------------------
---- FOCUS (MOVE) ----
---------------------

-- Arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Vim keys
hl.bind(mainMod .. " + H",    hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L",    hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J",    hl.dsp.focus({ direction = "d" }))

-----------------------
---- MOVE WINDOW ----
-----------------------

-- Arrow keys
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Vim keys
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

------------------------
---- LAYOUT SWITCH ----
------------------------

-- SUPER+I → dwindle,  SUPER+M → master
-- Setting layout at runtime via hl.config() is the Lua equivalent of
-- `hyprctl keyword general:layout "..."` from the old config.
hl.bind(mainMod .. " + I", function()
    hl.config({ general = { layout = "dwindle" } })
end)

hl.bind(mainMod .. " + M", function()
    hl.config({ general = { layout = "master" } })
end)

-- On RELEASE of SUPER+M, move the active window left as a "promote to master"
-- hack (mirrors the `bindr = $mainMod, M, movewindow, l` from your old conf).
-- Verify the exact dispatcher name via the LSP or wiki if this misbehaves.
hl.bind(mainMod .. " + M", hl.dsp.window.move({ direction = "l" }), { release = true })

--------------------------
---- WORKSPACE SWITCH ----
--------------------------

-- SUPER + [1-9, 0]  →  switch to workspace
-- SUPER + SHIFT + [1-9, 0]  →  move window there (silent)
for i = 1, 10 do
    local key = i % 10  -- 10 → key 0
    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i, silent = true }))
end

-- SUPER + ,/.  →  previous/next workspace
hl.bind(mainMod .. " + comma",        hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind(mainMod .. " + period",       hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ workspace = "e+1" }))

-- Scroll through workspaces with SUPER + mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad / special workspace
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

------------------------------------
---- MOVE / RESIZE WITH MOUSE ----
------------------------------------

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------
---- SCREENSHOTS ----
--------------------------

-- Print  →  region screenshot → clipboard (+ notification)
hl.bind("Print", hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot copied to clipboard — Super+Ctrl+S for swappy, Super+Shift+S for fullscreen"]]
))

-- SUPER+Ctrl+S  →  region screenshot → swappy (annotation)
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | swappy -f -]]
))

-- SUPER+Shift+S  →  fullscreen screenshot → swappy
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(
    [[grim - | swappy -f -]]
))

--------------------------------------
---- LAPTOP MULTIMEDIA KEYS ----
--------------------------------------

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),      { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),                          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                          { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
