--
-- An Example from:
-- http://www.xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Configuring.html
--

import IO
import XMonad
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import System.IO
import System.Exit
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Shell
import XMonad.Prompt.AppLauncher as AL
import XMonad.Prompt.XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.CycleWS

-- Basic Configuration
-------------------------------------------------------------------------------
--
-- Set the default terminal
--
myTerminal = "urxvtc"

--
-- Set the Mod Key
--
myModMask = mod4Mask

--
-- Workspaces
-- 

myWorkspaces = ["1","2" ] ++ map show [3..9]

--
-- Colors and Such
--
myBorderWidth = 0
myNormalBorderColor = "#000000"
myFocusedBorderColor= "#0593e8"

--
-- Mouse pointer
--
--setDefaultCursor	xC_left_ptr

-------------------------------------------------------------------------------

--
-- New Keybindings
--
--myKeys conf@(XConfig {XMonad.modMask = mod4Mask}) = M.fromList $

newKeys x =
			     [ ((modMask x, 			xK_o ), AL.launchApp prompt' "ql" )
			      ,((modMask x, 			xK_x ),  shellPrompt prompt' ) 
				  ,((mod1Mask,			xK_m ), spawn "gmusicbrowser" )
				  ,((modMask x,			xK_f ), spawn "firefox -P navigation3 --no-remote" )
				  ,((modMask x .|. shiftMask,	xK_f ), spawn "firefox -P maidens3 --no-remote")
				  ,((0,					0x1008ff14), spawn "gmusicbrowser -remotecmd PlayPause" ) -- play/pause song with gmusicbrowser
				  ,((0,					0x1008ff15), spawn "gmusicbrowser -remotecmd Stop" ) -- stop song with gmusicbrowser
				  ,((0,					0x1008ff16), spawn "gmusicbrowser -remotecmd PrevSongInPlaylist" ) -- skip to previous song in gmusicbrowser
				  ,((0,					0x1008ff17), spawn "gmusicbrowser -remotecmd NextSongInPlaylist" ) -- skip to next song in gmusicbrowser
				  ,((0,					0x1008ff11), spawn "amixer set Master 2dB-" ) -- lower volume
				  ,((0,					0x1008ff13), spawn "amixer set Master 2dB+" ) -- raise volume
				  ,((0,					0x1008ff12), spawn "amixer set Master 0%" ) -- mute soundcard
				  ,((0,					0x1008ff2f), spawn "xscreensaver-command -lock" ) -- lock screen with xscreensaver
				  ,((modMask x,			xK_q), focusUrgent) -- focus the latest urgent window
				  ,((modMask x,			xK_Escape), toggleWS) -- move to the previous workspace
				  ]

myKeys x = M.union (keys defaultConfig x) (M.fromList (newKeys x))

--
-- Floating Windows
--
myManageHook = composeAll     [ className  =? "feh"  		--> doFloat 
                              , className  =? "glxgears"  	--> doFloat 
                              , className  =? "mplayer" 	--> doFloat 
							  , className  =? "gcolor2"		--> doFloat
							  , className  =? "Gmusicbrowser" --> doFloat
							  , className  =? "skype"		--> doFloat
							  , className  =? "hp-toolbox"	--> doFloat
							  , className  =? "Pidgin"		--> doShift "6"
							  , className  =? "Chats"		--> doShift "6"
							  , role  =? "gimp-toolbox" --> doFloat
							  , role  =? "gimp-toolbox" --> doShift "5"
							  , role  =? "gimp-image-window" --> doShift "5"
							  , className  =? "dialog"	--> doFloat
							  , role  =? "Preferences"	--> doFloat
							  , className  =? "firefox"		--> doFloat
                              , composeOne [ isFullscreen -?> doFullFloat ] ]
							  where role = stringProperty "WM_WINDOW_ROLE"

prompt' = defaultXPConfig {      font = "xft:ProFont:pixelsize=13:antialias=true:hinting=true"
			--      , bgColor = "#000000"
			        , defaultText  = ""
			        , fgColor = "#ff7f14"
					, bgColor = "#1b1d1a"
			        , bgHLight = "#ff7f14"
			        , fgHLight = "#1b1d1a"
			        , borderColor = "#000000"
			        , promptBorderWidth = 0
			        , position = Bottom
			        , height = 13 
			        , historySize = 256 }

--
-- Status bars and logging
--
newManageHook = myManageHook <+> manageHook defaultConfig <+> manageDocks
--MYLAYOUTHOOK = avoidStruts $ smartBorders $ layoutHook defaultConfig ||| Grid
myLayoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig ||| Grid

--
-- Dzen
--
--myDzenPP h = defaultPP
--	{ ppCurrent = dzenColor fgColor bgColor . pad
--	, ppHiddenNoWindows	= dzenColor fgColor bgColor . pad
--	, ppLayout	= dzenColor fgColor bgColor . pad
--	, ppUrgent	= wrap (dzenColor "#ff0000" "" "{") (dzenColor "#ff0000" "" "}") . pad
--	, ppTitle	= wrap "^fg(#909090)[ " " ]^fg()" . shorten 40
--	, ppWsSep	= ""
--	, ppSep		= " "
--	, ppOutput	= hPutStrLn h
--	}

--DzenCommand = "dzen2 -ta -l -fg '" ++ fgColor ++ "' -bg '" ++ bgColor ++ "' -e 'button3='"
	

-------------------------------------------------------------------------------


--
-- The main loop
--

main = do
        xmobar <- spawnPipe "xmobar"  -- spawns xmobar and returns a handle
		--dzen <- spawnPipe DzenCommand
        xmonad $  withUrgencyHook NoUrgencyHook defaultConfig {

        -- Simple Stuff
                  terminal                = myTerminal
				, keys					  = myKeys
                , modMask                 = myModMask
				, workspaces			  = myWorkspaces
                , borderWidth             = myBorderWidth
                , normalBorderColor       = myNormalBorderColor
                , focusedBorderColor      = myFocusedBorderColor

        -- Hooks, layouts
                -- print the output of xmobarPP to the handle
                , logHook = dynamicLogWithPP $ xmobarPP { 
					ppOutput = hPutStrLn xmobar 
					, ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
					, ppTitle = xmobarColor "#ff7f14" "" . shorten 50
					} 
				--, logHook = dynamicLogWithPP $ myDzenPP dzen
                , manageHook      = newManageHook
                , layoutHook      = myLayoutHook
				, startupHook	  = setDefaultCursor xC_left_ptr
        }
