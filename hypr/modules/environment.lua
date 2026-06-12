-- modules/environment.lua
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE",         "24")
hl.env("XCURSOR_THEME",        "Default")
hl.env("HYPRCURSOR_THEME",     "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE",      "36")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if you have that

-- fcitx5 input method environment variables.
-- See https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
-- These are intentionally kept even though the wiki suggests omitting them,
-- because some apps misbehave without them.
hl.env("GTK_IM_MODULE",  "fcitx")
hl.env("QT_IM_MODULE",   "fcitx")
hl.env("GLFW_IM_MODULE", "fcitx")
hl.env("XMODIFIERS",     "@im=fcitx")
