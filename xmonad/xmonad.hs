import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks

import XMonad.Util.EZConfig 
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Util.SpawnOnce
import XMonad.Layout.ThreeColumns

main :: IO ()
main = xmonad 
      . ewmhFullscreen 
      . ewmh 
      . docks
      $ myConfig

myConfig = def
    { terminal = "kitty" 
    , modMask = mod4Mask
    , layoutHook = myLayout
    , manageHook = myManageHook
    , startupHook = myStartupHook
    }
  `additionalKeysP`
    [ ("M-S-=", unGrab *> spawn "scrot -s")
    , ("M-]"  , spawn browser             )
    , ("M-p"  , spawn applicationLauncher )
    ]
    where
        browser              = "google-chrome-stable"
        applicationLauncher  = "rofi -show run"

myManageHook :: ManageHook
myManageHook = composeAll
    [ isDialog --> doFloat
    ]

myStartupHook :: X ()
myStartupHook = do
    spawn "polybar-msg cmd quit"
    
    -- Spawn polybar bars
    spawn "polybar screen1 2>&1 | tee -a /tmp/polybar-screen1.log & disown"
    spawn "polybar screen2 2>&1 | tee -a /tmp/polybar-screen2.log & disown"

myLayout = avoidStruts $ 
    tiled ||| Mirror tiled ||| Full ||| ThreeColMid nmaster delta ratio
    where
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100


