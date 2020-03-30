-- {{{ License
-- rc.lua, works with awesome 4.0 on Arch Linux
-- author: Donearm <forod [dot] g [at] gmail.com>
--
-- This work is licensed under the Creative Commons Attribution Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

-- Custom functions
local functions = require("functions")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

--        naughty.notify({ preset = naughty.config.presets.critical,
--                         title = "Oops, an error happened!",
--                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local terminal = "kitty"
local editor = os.getenv("EDITOR") or "gvim"
local editor_cmd = terminal .. " -e " .. editor
local home = os.getenv("HOME")
local browser = "apulse " .. os.getenv("BROWSER")
local music = terminal .. " -e ncmpcpp"
local musicPlay = "mpc toggle"
local musicStop = "mpc stop"
local musicPrev = "mpc prev"
local musicNext = "mpc next"
local soundRaiseVolume = "amixer set Master 3dB+ unmute"
local soundLowerVolume = "amixer set Master 3dB- unmute"
local soundPerfectVolume = "amixer set Master 10% unmute"
local soundMute = "amixer set Master mute"
local filemanager = terminal .. " -e ranger"
local mutt = terminal .. " -e mutt -y"
local lockScreen = "slock"
local brightnessInc = "xbacklight -inc 10"
local brightnessDec = "xbacklight -dec 10"
-- Themes define colours, icons, and wallpapers
theme_path = home .. "/.config/awesome/themes/joker"
-- Actually load theme
beautiful.init(theme_path)
-- Define if we want to see naughty notifications
use_naughty = true
naughty.config.presets.normal.border_color = beautiful.menu_border_color
naughty.config.border_width = 2
-- Naughty notifications opacity
naughty.config.presets.normal.opacity = 1
naughty.config.presets.low.opacity = 0.8
naughty.config.presets.critical.opacity = 1
-- Define if we want to modify client.opacity
use_composite = false

-- menu bindings
awful.menu.menu_keys = { up     = { "k", "Up" },
                         down   = { "j", "Down" },
                         exec   = { "i", "Return", "Right" },
                         enter  = { "Right" },
                         back   = { "h", "Left" },
                         close  = { "q", "Escape" },
                     }

-- Alt is Mod1
alt = "Mod1"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,             -- [1]
    awful.layout.suit.tile.left,        -- [2]
    awful.layout.suit.tile.bottom,      -- [3]
    awful.layout.suit.tile.top,         -- [4]
    awful.layout.suit.fair,             -- [5]
    awful.layout.suit.fair.horizontal,  -- [6]
    awful.layout.suit.max,              -- [7]
    awful.layout.suit.max.fullscreen,   -- [8]
    awful.layout.suit.magnifier,        -- [9]
    awful.layout.suit.floating,         -- [10]
    awful.layout.suit.spiral,           -- [11]
    awful.layout.suit.spiral.dwindle,   -- [12]
    awful.layout.suit.corner.nw			-- [13]
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "lock screen", lockScreen },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   { "reboot", "sudo systemctl reboot"}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesomewm_image },
                                        { "open terminal", terminal, beautiful.terminal_image },
                                        { "firefox", browser, beautiful.firefox_image },
                                        { "ranger", filemanager, beautiful.filemanager_image },
                                        { "Music", music, beautiful.music_image },
                                      }
                            })

-- Launchbox
mylauncher = awful.widget.launcher({ image = beautiful.archlinux_image,
                                    menu = mymainmenu })
-- Top Statusbar widgets

-- Cpu widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.cpu_icon)
cpuwidget = wibox.widget.textbox()
cpuwidget:connect_signal("mouse::enter", function () psByCpu(0) end)
cpuwidget:connect_signal("mouse::leave", function () psByCpu(1) end)
vicious.register(cpuwidget, vicious.widgets.cpu,
    function (widget, args)
        if (args[2] > 50) and (args[3] > 50) and (args[4] > 50) and (args[5] > 50) then
		return setFg(beautiful.fg_divisions, '[') .. setFg(beautiful.fg_focus, args[2] .. '%') .. setFg(beautiful.fg_divisions, '][') .. setFg(beautiful.fg_focus, args[3] .. '%') .. setFg(beautiful.fg_divisions, '][')
		.. setFg(beautiful.fg_focus, args[4] .. '%') .. setFg(beautiful.fg_divisions, '][') .. setFg(beautiful.fg_focus, args[5] .. '%') .. setFg(beautiful.fg_divisions, ']'), 5
	elseif args[2] > 50 then
		return setFg(beautiful.fg_divisions, '[') .. setFg(beautiful.fg_focus, args[2] .. '%') .. setFg(beautiful.fg_divisions, '][') .. args[3] .. '%' .. setFg(beautiful.fg_divisions, '][')
		.. args[4] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[5] .. '%' .. setFg(beautiful.fg_divisions, ']'), 5
	elseif args[3] > 50 then
		return setFg(beautiful.fg_divisions, '[') .. args[2] .. '%' .. setFg(beautiful.fg_divisions, '][') .. setFg(beautiful.fg_focus, args[3] .. '%') .. setFg(beautiful.fg_divisions, '][')
		.. args[4] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[5] .. '%' .. setFg(beautiful.fg_divisions, ']'), 5
	elseif args[4] > 50 then
		return setFg(beautiful.fg_divisions, '[') .. args[2] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[3] .. '%' .. setFg(beautiful.fg_divisions, '][')
		.. setFg(beautiful.fg_focus, args[4] .. '%') .. setFg(beautiful.fg_divisions, '][') .. args[5] .. '%' .. setFg(beautiful.fg_divisions, ']'), 5
	elseif args[5] > 50 then
		return setFg(beautiful.fg_divisions, '[') .. args[2] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[3] .. '%' .. setFg(beautiful.fg_divisions, '][')
		.. args[4] .. '%' .. setFg(beautiful.fg_divisions, '][') .. setFg(beautiful.fg_focus, args[5] .. '%') .. setFg(beautiful.fg_divisions, ']'), 5
	else
		return setFg(beautiful.fg_divisions, '[') .. args[2] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[3] .. '%' .. setFg(beautiful.fg_divisions, '][')
		.. args[4] .. '%' .. setFg(beautiful.fg_divisions, '][') .. args[5] .. '%' .. setFg(beautiful.fg_divisions, ']'), 5
	end
end, 5
)


-- Memory widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.ram_icon)
memwidget = wibox.widget.textbox()
memwidget:connect_signal("mouse::enter", function () psByMemory(0) end)
memwidget:connect_signal("mouse::leave", function () psByMemory(1) end)
vicious.register(memwidget, vicious.widgets.mem,
function (widget, args)
	if args[1] > 70 then
		return setFg(beautiful.fg_focus, args[1] .. '%') .. setFg(beautiful.fg_divisions, '|') .. setFg(beautiful.fg_focus, args[2] .. 'MB'), 10
	else
		return args[1] .. '%' .. setFg(beautiful.fg_divisions, '|') .. args[2] .. 'MB', 10
	end
end, 10
)


-- Network widget
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.net_up_icon)
netupwidget = wibox.widget.textbox()
-- the last 3 options are interval-in-seconds, properties-name, padding
vicious.cache(vicious.widgets.net)
vicious.register(netupwidget, vicious.widgets.net,
function (widget, args)
	if tonumber(args["{wlp7s0 up_kb}"]) > 80 then
		return setFg(beautiful.fg_focus, args["{wlp7s0 up_kb}"]), nil, nil, 3
	else
		return args["{wlp7s0 up_kb}"], nil, nil, 3
	end
end, nil, nil, 3
)

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.net_down_icon)
netdownwidget = wibox.widget.textbox()
vicious.register(netdownwidget, vicious.widgets.net,
function (widget, args)
	if tonumber(args["{wlp7s0 down_kb}"]) > 200 then
		return setFg(beautiful.fg_focus, args["{wlp7s0 down_kb}"]), nil, nil, 3
	else
		return args["{wlp7s0 down_kb}"], nil, nil, 3
	end
end, nil, nil, 3
)


-- Bottom Statusbar widgets

-- Task widget
taskicon = wibox.widget.imagebox()
taskicon:set_image(beautiful.taskwarrior_image)
taskicon:buttons(awful.util.table.join(
awful.button({ }, 1, function() taskShow() end)
)
)

-- Mpd icon
mpdicon = wibox.widget.imagebox()

-- Mpd widget
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
function (widget, args)
if args["{state}"] == "Stop" then
	mpdicon:set_image(beautiful.transparent_image)
	return ""
elseif args["{state}"] == "Play" then
	mpdicon:set_image(beautiful.playing_image)
	return ' ' .. setFg(beautiful.fg_divisions, '[') .. args["{Artist}"] .. ' - ' .. args["{Album}"] .. ' - ' .. args["{Title}"] .. setFg(beautiful.fg_divisions, '] ')
elseif args["{state}"] == "Pause" then
	mpdicon:set_image(beautiful.pause_playing_image)
	return ' ' .. setFg(beautiful.fg_divisions, '[') .. args["{Artist}"] .. ' - ' .. args["{Album}"] .. ' - ' .. args["{Title}"] .. setFg(beautiful.fg_divisions, '] ')
else
	return ''
end
end, 2 )
mpdwidget:buttons(
awful.util.table.join(
	awful.button({}, 1, function () awful.spawn(musicPlay, false) end),
	awful.button({}, 3, function () awful.spawn(music) end),
	awful.button({}, 4, function () awful.spawn(musicNext, false) end),
	awful.button({}, 5, function () awful.spawn(musicPrev, false) end)
)
)

-- Battery widget
batwidget = wibox.widget.textbox()
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.battery_icon)
vicious.register(batwidget, vicious.widgets.bat,
function (widget, args)
	local state = args[1]
	local charge = args[2]
	local bat_time = args[3]
	if charge == 100 then
		return ' ' .. charge .. '% ' .. setFg(beautiful.fg_divisions, '[') .. 'Charged' .. setFg(beautiful.fg_divisions, ']')
	else
		if state == "-" then
			return ' ' .. charge .. '% ' .. setFg(beautiful.fg_divisions, '[') .. bat_time .. ' left' .. setFg(beautiful.fg_divisions, ']')
		elseif state == "+" then
			return ' ' .. charge .. '% ' .. setFg(beautiful.fg_divisions, '[') .. bat_time .. ' to full charge' .. setFg(beautiful.fg_divisions, ']')
		else
			return ' '
		end
	end
end,
62, 'BAT0')

-- Volume widget
volumewidget = wibox.widget.textbox()
volumeicon = wibox.widget.imagebox()
volumeicon:set_image(beautiful.speaker_icon)
-- enable caching
vicious.cache(vicious.widgets.volume)
vicious.register(volumewidget, vicious.widgets.volume, "$1% ", 1, "Master")
volumewidget:buttons(awful.util.table.join(
awful.button({ }, 1, function() awful.spawn(soundPerfectVolume) end),
awful.button({ }, 4, function() awful.spawn(soundRaiseVolume) end),
awful.button({ }, 5, function() awful.spawn(soundLowerVolume) end),
awful.button({ }, 3, function() awful.spawn(soundMute) end)
))

-- Date widget
datebox = wibox.widget.textbox()
datebox:connect_signal("mouse::enter", function () addCalendar(0) end)
datebox:connect_signal("mouse::leave", function () removeCalendar() end)
datebox:buttons(awful.util.table.join(
awful.button({ }, 4, function () addCalendar(-1) end),
awful.button({ }, 5, function () addCalendar(1) end)
))
vicious.register(datebox, vicious.widgets.date, " %T %F ")


-- {{{ Wibox

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Set the default text in textbox
mypromptbox = wibox.widget.textbox()

-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
				awful.button({ }, 1, function(t) t:view_only() end),
				awful.button({ modkey }, 1, function(t)
					if client.focus then
						client.focus:move_to_tag(t)
					end
				end),
				awful.button({ }, 3, awful.tag.viewtoggle),
				awful.button({ modkey }, 3, function(t)
					if client.focus then
						client.focus:toggle_tag(t)
					end
				end),
				awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
				awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
			)

local tasklist_buttons = gears.table.join(
				awful.button({ }, 1, function (c)
											if c == client.focus then
												c.minimized = true
											else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

    -- Each screen has its own tag table.
--	awful.tag({ "♒", "♂", "∞", "⚒", "☥", "♔", "☢", "A", "B"}, s, awful.layout.layouts[1])
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(awful.util.table.join(
			awful.button({ }, 1, function () awful.layout.inc(1) end),
			awful.button({ }, 3, function () awful.layout.inc(-1) end),
			awful.button({ }, 4, function () awful.layout.inc(1) end),
			awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist  {
		screen = s, 
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons
	}

	-- Create the top wibar
	s.topwibox = awful.wibar({
	position = "top",
	screen = s,
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	height = 18 })

	local topwibox_left = wibox.layout.fixed.horizontal()
	topwibox_left:add(s.mytaglist)
	topwibox_left:add(mylauncher)
	topwibox_left:add(s.mypromptbox)

	local topwibox_right = wibox.layout.fixed.horizontal()
	topwibox_right:add(cpuicon)
	topwibox_right:add(cpuwidget)
	topwibox_right:add(memicon)
	topwibox_right:add(memwidget)
	topwibox_right:add(netupicon)
	topwibox_right:add(netupwidget)
	topwibox_right:add(netdownicon)
	topwibox_right:add(netdownwidget)
	topwibox_right:add(mysystray)

	local topwibox_layout = wibox.layout.align.horizontal()
	topwibox_layout:set_left(topwibox_left)
	topwibox_layout:set_right(topwibox_right)
	topwibox_layout:set_middle(s.mytasklist) -- tasklist, alone, occupies the remaining space in the middle
	s.topwibox:set_widget(topwibox_layout)

	-- Create the bottom wibox
	s.bottomwibox = awful.wibar({
		position = "bottom",
		screen = s,
		fg = beautiful.fg_normal,
		bg = beautiful.bg_normal,
		height = 18 })

	local bottomwibox_left = wibox.layout.fixed.horizontal()
	bottomwibox_left:add(s.mylayoutbox)

	local bottomwibox_right = wibox.layout.fixed.horizontal()
	bottomwibox_right:add(mpdicon)
	bottomwibox_right:add(mpdwidget)
	bottomwibox_right:add(baticon)
	bottomwibox_right:add(batwidget)
	bottomwibox_right:add(volumeicon)
	bottomwibox_right:add(volumewidget)
	bottomwibox_right:add(datebox)

	local bottomwibox_layout = wibox.layout.align.horizontal()
	bottomwibox_layout:set_left(bottomwibox_left)
	bottomwibox_layout:set_right(bottomwibox_right)
	s.bottomwibox:set_widget(bottomwibox_layout)
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

	-- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- DailyActivties popup
	awful.key({ modkey,             }, "a", function () dailyActivities()             end),
	awful.key({ modkey, alt         }, "m", function () awful.spawn(music) end),
	awful.key({ modkey, alt         }, "f", function () awful.spawn(browser) end),
	awful.key({ modkey, alt         }, "r", function () awful.spawn(filemanager) end),
	awful.key({ modkey, alt         }, "p", function () show_clipboard() end),
	awful.key({ modkey, "Control"   }, "m", function() mouse.coords({x=800, y=1500}, true) end),
	awful.key({ modkey,             }, "c", function() simulateClick() end),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

	-- Prompt
	awful.key({ modkey              }, "r", function () mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey				}, "r", function () awful.screen.focused().mypromptbox:run() end),

	awful.key({ modkey }, "x",
			function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
				}
			end,
			{description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Compute the maximum number of digit we need, limited to 9
--keynumber = 0
--awful.screen.connect_for_each_screen(function(s)
--	keynumber = math.min(9, math.max(awful.tag.gettags(s), keynumber))
--end)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--for i = 1, keynumber do
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
						border_color = beautiful.border_normal,
						focus = awful.client.focus.filter,
						raise = true,
						keys = clientkeys,
						maximized = false,
						maximized_vertical = false,
						maximized_horizontal = false,
						buttons = clientbuttons,
						screen = awful.screen.preferred,
						placement = awful.placement.no_overlap+awful.placement.no_offscreen
					}
	},
		-- Floating clients.
	{ rule_any = {
		instance = {
			"MPlayer",
			"mpv",
		},
		class = {
			"<unknown>",
			"plugin-container",
			"Wine",
			"Skype"
		},
	}, properties = { floating = true },
	{ rule = { class = "Firefox" },
		properties = { screen = 1, tag = 1 } },
	{ rule = { class = "Spotify" },
		properties = { screen = 1, tag = 5 } },
	}
}

-- {{{ Autorun apps
autorun = true

--- New way
if autorun then
	run_once("xbindkeys")
	run_once("setxkbmap -option compose:menu") -- menu key is Compose
	run_once("~/Script/script_disable_touchpad.sh")
    run_once("xset", "m 0.7 2")
    run_once("xset", "dpms 0 120 600")
	run_once("xrandr", "--dpi 123")
    run_once(browser)
	run_once("spotify")
end

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--- Periodically check if something is playing and if not, set back
--audio to a low volume
local audio_timer = gears.timer { timeout = 301 }
audio_timer:connect_signal("timeout", function()
	if audio_playing() == false then
		awful.spawn(soundPerfectVolume)
	end
end)
audio_timer:start()

-- vim: set filetype=lua tabstop=4 shiftwidth=4:
