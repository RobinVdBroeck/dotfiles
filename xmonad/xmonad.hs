import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig 
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

import XMonad.Layout.ThreeColumns

main :: IO ()
main = xmonad 
      . ewmhFullscreen 
      . ewmh 
      . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
      $ myConfig

myConfig = def
    { terminal = "kitty" 
    , modMask = mod4Mask
    , layoutHook = myLayout
    , manageHook = myManageHook
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

myLayout = tiled ||| Mirror tiled ||| Full ||| ThreeColMid nmaster delta ratio
    where
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
