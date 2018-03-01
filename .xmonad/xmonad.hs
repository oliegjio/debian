import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import XMonad.Util.Run

main = do
  xmonad =<< xmobar (defaultConfig
    { terminal = "sakura"
    , modMask = mod4Mask
    , borderWidth = 1
    , normalBorderColor = "#888800"
    , focusedBorderColor = "#ffff00"
    } `additionalKeysP` myAdditionalKeys)

myAdditionalKeys =
  [
    ("<XF86AudioRaiseVolume>",  spawn "amixer -q sset Master 2%+"),
    ("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 2%-"),
    ("<XF86AudioMute>", spawn "amixer set Master toggle"),
    ("<XF86MonBrightnessUp>", spawn "brightness-up 50"),
    ("<XF86MonBrightnessDown>", spawn "brightness-down 50")
  ]

