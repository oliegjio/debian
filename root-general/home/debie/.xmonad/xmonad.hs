import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.NamedScratchpad
import XMonad.StackSet
import XMonad.Layout.NoBorders
import XMonad.Util.Cursor
import XMonad.Layout.IndependentScreens
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import System.IO

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks defaultConfig
    { terminal           = "sakura"
    , modMask            = mod4Mask
    , borderWidth        = 1
    , handleEventHook    = myHandleEventHook
    , normalBorderColor  = "#888800"
    , focusedBorderColor = "#ffff00"
    , layoutHook         = myLayoutHook
    , logHook            = dynamicLogWithPP xmobarPP
                         { ppOutput = hPutStrLn xmproc
                         , ppTitle  = xmobarColor "green" "" . shorten 50
                         }
    , startupHook        = myStartupHook
    , manageHook         = myManageHook
    } `additionalKeysP` myAdditionalKeysP

detectScreens = do
  count <- countScreens
  if count > 1
    then spawn "xrandr --output eDP-1 --auto --output HDMI-1 --off"
    else spawn "xrandr --output eDP-1 --auto --scale 1x1 --output HDMI-1 --auto --scale 1x1 --left-of eDP-1"

myHandleEventHook = fullscreenEventHook

myStartupHook = do
  detectScreens
  setDefaultCursor xC_left_ptr
  spawn "feh --bg-fill /home/debie/Pictures/golden-bridge.jpg"
  spawn "dropbox start"
  startupHook defaultConfig

myAdditionalKeysP =
  [ ("<XF86AudioRaiseVolume>" , spawn "amixer -q sset Master 2%+")
  , ("<XF86AudioLowerVolume>" , spawn "amixer -q sset Master 2%-")
  , ("<XF86AudioMute>"        , spawn "amixer set Master toggle" )
  , ("<XF86MonBrightnessUp>"  , spawn "brightness-up 25"         )
  , ("<XF86MonBrightnessDown>", spawn "brightness-down 25"       )
  , ("M-z"                    , spawn "slock"                    )
  , ("M-p"                    , spawn "dmenu_run -fn 'Monaco-15'")
  , ("M-<Esc>"                , scratchPadTerminal               )
  , ("M-<Insert>"             , detectScreens                    )
  ]
    
myLayoutHook = smartBorders $ avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1     -- The default number of windows in the master pane
    ratio   = 1/2   -- Default proportion of screen occupied by master pane
    delta   = 3/100 -- Percent of screen to increment by when resizing panes

scratchPadTerminal = namedScratchpadAction myScratchpads "terminal"
myScratchpads = [NS "terminal" spawnTerm findTerm manageTerm]
  where
    spawnTerm  = "sakura --class scratchpad --name scratchpad"
    findTerm   = className =? "scratchpad"
    manageTerm = (customFloating $ RationalRect l t w h)
      where
        h = 0.4
        w = 1
        t = 1 - h
        l = 1 - w

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Viewnior"      --> doFloat
  , className =? "Dialog"        --> doFloat
  , className =? "immersiveShow" --> doFloat
  , namedScratchpadManageHook myScratchpads
  , manageDocks
  , manageHook defaultConfig
  ]

