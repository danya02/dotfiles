-- modules/autostart.lua
-- Commands to run at startup.
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- hl.on("hyprland.start", ...)  →  runs ONCE at session start (like exec-once)
-- hl.exec_cmd(...) at top level  →  runs on every config reload (like plain exec)

-- fcitx5: re-run on every reload so it picks up any config changes.
-- The -d flag starts it as a daemon; -r restarts if already running; --keep
-- keeps running even if no frontend is connected.
hl.exec_cmd("fcitx5 -dr --keep")

-- Register graphical session target on every reload (safe to repeat)
hl.exec_cmd("systemctl --user start hyprland-session.target")

hl.on("hyprland.start", function()
    -- System services
    hl.exec_cmd("systemctl --user start plasma-polkit-agent.service")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systembus-notify -q")

    -- Clipboard manager (text + images)
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Status bar (small delay so the Wayland socket is ready)
    hl.exec_cmd("sleep 1 && eww daemon --force-wayland && eww open bar")

    -- Launch apps on specific workspaces silently.
    -- See https://wiki.hypr.land/FAQ/ for the { workspace = "N" } syntax.
    hl.exec_cmd("kitty",             { workspace = "1" })
    hl.exec_cmd("firefox",           { workspace = "2" })
    hl.exec_cmd("telegram-desktop",  { workspace = "9" })
    hl.exec_cmd("thunderbird",       { workspace = "10" })
end)
