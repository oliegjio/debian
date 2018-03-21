import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Scratchpad
import XMonad.StackSet
import XMonad.Layout.NoBorders

myTerminal = "sakura"

main = do
  xmonad =<< xmobar (defaultConfig
    { terminal           = myTerminal
    , modMask            = mod4Mask
    , borderWidth        = 1
    , handleEventHook    = fullscreenEventHook
    , normalBorderColor  = "#888800"
    , focusedBorderColor = "#ffff00"
    , layoutHook         = smartBorders $ myLayout
    , manageHook         = myManageHook <+> manageScratchPad
                                        <+> manageHook defaultConfig
    } `additionalKeysP` myAdditionalKeys)

myAdditionalKeys =
  [ ("<XF86AudioRaiseVolume>" , spawn "amixer -q sset Master 2%+")
  , ("<XF86AudioLowerVolume>" , spawn "amixer -q sset Master 2%-")
  , ("<XF86AudioMute>"        , spawn "amixer set Master toggle" )
  , ("<XF86MonBrightnessUp>"  , spawn "brightness-up 50"         )
  , ("<XF86MonBrightnessDown>", spawn "brightness-down 50"       )
  , ("M-z"                    , spawn "slock"                    )
  , ("M-p"                    , spawn "dmenu_run -fn 'Monaco-15'")
  , ("M-<Esc>"                , scratchPad                       )
  ]
  where
    scratchPad = scratchpadSpawnActionTerminal myTerminal

myLayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Viewnior"      --> doFloat
  , className =? "Dialog"        --> doFloat
  , className =? "immersiveShow" --> doFloat
  ]

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (RationalRect l t w h)
  where
    h = 0.1
    w = 1
    t = 1 - h
    l = 1 - w

