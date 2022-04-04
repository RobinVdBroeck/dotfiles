import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive

import XMonad.Util.EZConfig 
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Util.SpawnOnce
import XMonad.Layout.ThreeColumns

-- Polybar imports
import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus                     as D
import qualified DBus.Client              as D

main :: IO ()
main = do
    dbus <- mkDbusClient
    xmonadSetup dbus

xmonadSetup :: D.Client -> IO ()
xmonadSetup dbus = xmonad
                   . ewmhFullscreen 
                   . ewmh 
                   . docks
                   $ myConfig dbus

myConfig dbus = def
    { terminal    = terminal 
    , modMask     = mod4Mask
    , layoutHook  = myLayout
    , manageHook  = myManageHook
    , startupHook = myStartupHook
    , logHook     = myPolybarLogHook dbus
    }
  `additionalKeysP`
    [ ("M-S-=", unGrab *> spawn "scrot -s")
    , ("M-]"  , spawn browser             )
    , ("M-p"  , spawn applicationLauncher )
    ]
    where
        terminal             = "kitty"
        browser              = "firefox"
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

    -- Located in .local/bin/scripts
    spawnOnce "wallpaper"

myLayout = avoidStruts $ 
    tiled ||| Mirror tiled ||| Full ||| ThreeColMid nmaster delta ratio
    where
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100

mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = dynamicLogWithPP $ polybarHook dbus 

