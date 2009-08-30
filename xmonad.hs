import XMonad
import System.Exit
import XMonad.Layout
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import IO
import XMonad.Util.Run

import XMonad.Config (defaultConfig)

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
 
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), restart "xmonad" True)
	, ((modm .|. shiftMask, xK_x	 ), spawn "xscreensaver-command -lock")
	, ((modm,				xK_g	 ), spawn "gmusicbrowser")
	, ((modm .|. mod1Mask,	xK_f	 ), spawn "firefox -P navigation3 --no-remote")
	, ((modm,				xK_f	 ), spawn "firefox -P maidens3 --no-remote")
    ]
    ++
 
        [((m .|. modm, k), windows $ f i) | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9], (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w)), 
    ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))]

myManageHook = composeAll
	[ className =? "Gimp"	--> doFloat
	, className =? "Gimp"	--> doShift "4"	-- send Gimp to workspace 4
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
	, className =? "Pidgin"			--> doShift "5"	-- send Pidgin to workspace 5
	, (className =? "Firefox" <&&> resource =? "Dialog")	--> doFloat -- make firefox dialogs float
	, className =? "MPlayer"	--> doIgnore
	, className =? "Gmusicbrowser"	--> doShift "6"
	]

myLayoutHook = avoidStruts $ smartBorders $
	onWorkspace "5" (named "IM" (reflectHoriz $ withIM (1%8) (Title "Buddy List") (reflectHoriz $ dwmStyle shrinkText myTheme tiled ||| (smartBorders $ tabs)))) $
	(tiled ||| named "Mirror" (Mirror tiled) ||| tabs)
		where
			tiled = named "Tall" (ResizableTall 1 (3/100) (1/2) [])
			tabs = named "Tabs" (tabbed shrinkText myTheme)
 
main = xmonad defaults

--defaults = defaultConfig {
defaults = do
	xmobar <- spawnPipe "xmobar"
	return $ defaultConfig {
        terminal           = "urxvt",
        focusFollowsMouse  = True,
        borderWidth        = 1,
        modMask            = mod4Mask,
        numlockMask        = mod2Mask,
        workspaces         = ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
        normalBorderColor  = "#000000",
        focusedBorderColor = "#ffffff",
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        logHook            = dynamicLogWithPP $ xmobarPP {
			ppOutput = hPutStrLn xmobar
			}
        startupHook        = spawn "urxvt"
    }
    where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100


