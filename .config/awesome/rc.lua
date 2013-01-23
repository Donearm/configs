-- {{{ License
-- rc.lua, works with awesome 3.5 on Arch Linux
-- author: Donearm <forod [dot] g [at] gmail.com>
--
-- This work is licensed under the Creative Commons Attribution Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ Load libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- Custom functions
local functions = require("functions")
--local mpdpopup = require("mpd-popup")

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
--                         text = err })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
-- Home directory
local terminal = "urxvt"
local editor = os.getenv("EDITOR") or "gvim"
local editor_cmd = terminal .. " -e " .. editor
local home = os.getenv("HOME")
local browser = "firefox"
local music = terminal .. " -e ncmpcpp"
local musicPlay = "ncmpcpp toggle"
local musicStop = "ncmpcpp stop"
local musicPrev = "ncmpcpp prev"
local musicNext = "ncmpcpp next"
local soundRaiseVolume = "amixer set Master 5%+ unmute"
local soundLowerVolume = "amixer set Master 5%- unmute"
local soundPerfectVolume = "amixer set Master 5% unmute"
local soundMute = "amixer set Master mute"
local filemanager = terminal .. " -e ranger"
local mutt = terminal .. " -e mutt -y"
local maildir = home .. "/Maildir"
local lockScreen = "slock"
-- Themes define colours, icons, and wallpapers
theme_path = home .. "/.config/awesome/themes/mellisaclarke01"
--theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Actually load theme
beautiful.init(theme_path)
-- the parentheses color
local par_color = beautiful.fg_focus
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
local layouts =
{
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
    awful.layout.suit.spiral.dwindle    -- [12]
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names = { "♒", "♂", "∞", "⚒", "☥", "♔", "☢"},
	layout = { layouts[1], layouts[1], layouts[7], layouts[1], layouts[1], layouts[1], layouts[1] }
}

for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "lock screen", lockScreen },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "reboot", "sudo reboot"}
}

-- Need more OSes? Greedy bitch...
vboxmenu = {
    { "WinXp", "VBoxManage startvm WinXp", beautiful.windows_image },
    { "Ubuntu", "VBoxManage startvm Ubuntu", beautiful.ubuntu_image }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesomewm_image },
                                        { "open terminal", terminal, beautiful.terminal_image },
                                        { "firefox", browser, beautiful.firefox_image },
                                        { "ranger", filemanager, beautiful.filemanager_image },
                                        { "Music", music, beautiful.music_image },
                                        { "Libreoffice", "soffice", beautiful.office_image },
                                        { "Skype", "skype", beautiful.skype_image },
                                        { "Gimp", "gimp", beautiful.gimp_image },
                                        { "Digikam", "digikam", beautiful.digikam_image },
                                        { "Other OS", vboxmenu, beautiful.vbox_image }
                                      }
                            })

-- Launchbox
mylauncher = awful.widget.launcher({ image = beautiful.archlinux_image,
                                    menu = mymainmenu })
-- Top Statusbar widgets

-- Cpu widget
cputag = wibox.widget.textbox()
cputag:set_text("CPU ")
--cpuwidget = widget({ type = "textbox" })
cpuwidget = wibox.widget.textbox()
cpuwidget:connect_signal("mouse::enter", function () psByCpu(0) end)
cpuwidget:connect_signal("mouse::leave", function () psByCpu(1) end)
vicious.register(cpuwidget, vicious.widgets.cpu,
    function (widget, args)
        if args[2] and args[3] > 50 then
            return setFg(par_color, '[') .. setFg(beautiful.fg_urgent, args[2] .. '%') .. setFg(par_color, '][') .. setFg(beautiful.fg_urgent, args[3] .. '%') .. setFg(par_color, ']'), 5
        elseif args[2] > 50 then
            return setFg(par_color, '[') .. setFg(beautiful.fg_urgent, args[2] .. '%') .. setFg(par_color, '][') .. args[3] .. '%' .. setFg(par_color, ']'), 5
        elseif args[3] > 50 then
            return setFg(par_color, '[') .. args[2] .. '%' .. setFg(par_color, '][') .. setFg(beautiful.fg_urgent, args[3] .. '%') .. setFg(par_color, ']'), 5
        else
            return setFg(par_color, '[') .. args[2] .. '%' .. setFg(par_color, '][') .. args[3] .. '%' .. setFg(par_color, ']'), 5
        end
    end, 5
)


-- Memory widget
memtag = wibox.widget.textbox()
--memtag.text = " RAM "
memtag:set_text(" RAM ")
memwidget = wibox.widget.textbox()
memwidget:connect_signal("mouse::enter", function () psByMemory(0) end)
memwidget:connect_signal("mouse::leave", function () psByMemory(1) end)
vicious.register(memwidget, vicious.widgets.mem, 
    function (widget, args)
        if args[1] > 70 then
            return setFg(beautiful.fg_urgent, args[1] .. '%') .. setFg(par_color, '|') .. setFg(beautiful.fg_urgent, args[2] .. 'MB'), 10
        else
            return args[1] .. '%' .. setFg(par_color, '|') .. args[2] .. 'MB', 10
        end
    end, 10
)


-- Network widget
netupwidget = wibox.widget.textbox()
-- the last 3 options are interval-in-seconds, properties-name, padding
vicious.cache(vicious.widgets.net)
vicious.register(netupwidget, vicious.widgets.net,
    function (widget, args)
        if tonumber(args["{eth0 up_kb}"]) > 80 then
            return setFg(beautiful.fg_urgent, args["{eth0 up_kb}"]) .. setFg(par_color, ' [') .. args["{eth0 tx_mb}"] .. 'M' .. setFg(par_color, ']'), nil, nil, 3
        else
            return args["{eth0 up_kb}"] .. setFg(par_color, ' [') .. args["{eth0 tx_mb}"] .. 'M' .. setFg(par_color, ']'), nil, nil, 3
        end
    end, nil, nil, 3
)
netdownwidget = wibox.widget.textbox()
vicious.register(netdownwidget, vicious.widgets.net,
    function (widget, args)
        if tonumber(args["{eth0 down_kb}"]) > 200 then
            return setFg(beautiful.fg_urgent, args["{eth0 down_kb}"]) .. setFg(par_color, ' [') .. args["{eth0 rx_mb}"] .. 'M' .. setFg(par_color, ']'), nil, nil, 3
        else
            return args["{eth0 down_kb}"] .. setFg(par_color, ' [') .. args["{eth0 rx_mb}"] .. 'M' .. setFg(par_color, ']'), nil, nil, 3
        end
    end, nil, nil, 3
)
netuptag = wibox.widget.textbox()
netuptag:set_text(" UP ")
netdowntag = wibox.widget.textbox()
netdowntag:set_text(" DOWN ")

-- Maildir widget
maildirtag = wibox.widget.textbox()
maildirtag:set_text(" MAIL ")
maildirwidget = wibox.widget.textbox()
vicious.register(maildirwidget, vicious.widgets.mdir, '$1 ', 300, { maildir })


-- Temperatures
--
cputemp = wibox.widget.textbox()
vicious.register(cputemp, vicious.widgets.thermal, "$1°C", 30, "thermal_zone0")
 
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
        return ' ' .. setFg(par_color, '[') .. args["{Artist}"] .. ' - ' .. args["{Album}"] .. ' - ' .. args["{Title}"] .. setFg(par_color, '] ')
    elseif args["{state}"] == "Pause" then
		mpdicon:set_image(beautiful.pause_playing_image)
        return ' ' .. setFg(par_color, '[') .. args["{Artist}"] .. ' - ' .. args["{Album}"] .. ' - ' .. args["{Title}"] .. setFg(par_color, ']') .. '{PAUSED} '
    end
end, 2 )
mpdwidget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function () awful.util.spawn(musicPlay, false) end),
        awful.button({}, 3, function () awful.util.spawn(music) end),
        awful.button({}, 4, function () awful.util.spawn(musicNext, false) end),
        awful.button({}, 5, function () awful.util.spawn(musicPrev, false) end)
    )
)

-- Volume widget
volumewidget = wibox.widget.textbox()
-- enable caching
vicious.cache(vicious.widgets.volume)
vicious.register(volumewidget, vicious.widgets.volume, "♫ $1% ", 1, "Master")
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.util.spawn(soundPerfectVolume) end),
    awful.button({ }, 4, function() awful.util.spawn(soundRaiseVolume) end),
    awful.button({ }, 5, function() awful.util.spawn(soundLowerVolume) end),
    awful.button({ }, 3, function() awful.util.spawn(soundMute) end)
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

-- Set the default text in textbox
mypromptbox = wibox.widget.textbox()

-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
topwibox = {}
bottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                            if c == client.focus then
                                                c.minimized = true
                                            else
                                                -- Without this, the following
                                                -- :isvisible() makes no sense
                                                c.minimized = false
                                                if not c:isvisible() then
                                                    awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Set a screen margin for borders
    awful.screen.padding(screen[s], { top = 0 })
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
			    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
			    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the top wibox
    topwibox[s] = awful.wibox({ 
        position = "top", 
        screen = s,
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal, 
        height = 18 })

    local topwibox_left = wibox.layout.fixed.horizontal()
    topwibox_left:add(mytaglist[s])
    topwibox_left:add(mylauncher)
    topwibox_left:add(mypromptbox[s])

    local topwibox_right = wibox.layout.fixed.horizontal()
    topwibox_right:add(cputag)
    topwibox_right:add(cputemp)
    topwibox_right:add(cpuwidget)
    topwibox_right:add(memtag)
    topwibox_right:add(memwidget)
    topwibox_right:add(netuptag)
    topwibox_right:add(netupwidget)
    topwibox_right:add(netdowntag)
    topwibox_right:add(netdownwidget)
    topwibox_right:add(maildirtag)
    topwibox_right:add(maildirwidget)
    topwibox_right:add(mysystray)

    local topwibox_layout = wibox.layout.align.horizontal()
    topwibox_layout:set_left(topwibox_left)
    topwibox_layout:set_right(topwibox_right)
    topwibox_layout:set_middle(mytasklist[s]) -- tasklist, alone, occupies the remaining space in the middle
    topwibox[s]:set_widget(topwibox_layout)

    -- Create the bottom wibox
    bottomwibox[s] = awful.wibox({
        position = "bottom",
        screen = s,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        height = 15 })
        
    local bottomwibox_left = wibox.layout.fixed.horizontal()
    bottomwibox_left:add(mylayoutbox[s])

    local bottomwibox_right = wibox.layout.fixed.horizontal()
	bottomwibox_right:add(mpdicon)
    bottomwibox_right:add(mpdwidget)
    bottomwibox_right:add(volumewidget)
    bottomwibox_right:add(datebox)

    local bottomwibox_layout = wibox.layout.align.horizontal()
    bottomwibox_layout:set_left(bottomwibox_left)
    bottomwibox_layout:set_right(bottomwibox_right)
    bottomwibox[s]:set_widget(bottomwibox_layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- DailyActivties popup
    awful.key({ modkey,             }, "a", function () dailyActivities()             end),
    awful.key({ modkey, alt         }, "m", function () awful.util.spawn(music) end),
    awful.key({ modkey, alt         }, "f", function () awful.util.spawn(browser) end),
    awful.key({ modkey, alt         }, "r", function () awful.util.spawn(filemanager) end),
    awful.key({ modkey              }, "p", function () show_clipboard() end),
    awful.key({ none                }, "XF86AudioPlay", function () awful.util.spawn(musicPlay) end),
    awful.key({ none                }, "XF86AudioStop", function () awful.util.spawn(musicStop) end),
    awful.key({ none                }, "XF86AudioPrev", function () awful.util.spawn(musicPrev) end),
    awful.key({ none                }, "XF86AudioNext", function () awful.util.spawn(musicNext) end),
    awful.key({ none                }, "XF86AudioLowerVolume", function () awful.util.spawn(soundLowerVolume) end),
    awful.key({ none                }, "XF86AudioRaiseVolume", function () awful.util.spawn(soundRaiseVolume) end),
    awful.key({ none                }, "XF86AudioMute", function () awful.util.spawn(soundMute) end),
    awful.key({ none                }, "XF86Sleep", function () awful.util.spawn(lockScreen) end),
    awful.key({ none                }, "XF86Mail", function () awful.util.spawn(mutt) end),
    awful.key({ modkey, "Control"   }, "m", function() moveMouse(safeCoords.x, safeCoords.y) end),
    awful.key({ modkey,             }, "c", function() simulateClick() end),

    -- Mod4+s set the window sticky; pressing it again leave the window
    -- only on the current tag
    awful.key({ modkey              }, "s", function ()
        for s = 1, screen.count( ) do
            tagtable = screen[s]:tags()
            for k,t in pairs(tagtable) do
                if t ~= awful.tag.selected() then
                    awful.client.toggletag ( t, c )
                end
            end
        end
    end),

    -- Prompt
    awful.key({ modkey              }, "r", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey              }, "x",
            function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                mypromptbox[mouse.screen].widget,
                awful.util.eval, nil,
                awful.util.getdir("cache") .. "/history_eval")
            end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f", function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o", awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r", function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t", function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"     }, "x", function (c) xprop(c) end),
    awful.key({ modkey,             }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
--                  end),
--        awful.key({ modkey, "Shift" }, "F" .. i,
--                  function ()
--                      local screen = mouse.screen
--                      if tags[screen][i] then
--                          for k, c in pairs(awful.client.getmarked()) do
--                              awful.client.movetotag(tags[screen][i], c)
--                          end
--                      end
--                   end),
--        -- unminimize windows
--        awful.key({ modkey, "Shift"   }, "n",
--            function ()
--                local allclients = client.get(mouse.screen)
--                for _,c in pairs(allclients) do
--                    if c.minimized and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen)
--                        then
--                            c.minimized = false
--                            client.focus = c
--                            c:raise()
--                            return
--                    end
--                end
--            end))
end
    

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true , tag = tags[1][5], switchtotag = true} },
    { rule = { role = "gimp-toolbox" },
      properties = { slave = true } },
    { rule = { role = "gimp-dock" },
      properties = { slave = true } },
    { rule = { class = "Shotwell" },
      properties = { tag = tags[1][5]} },
    { rule = { class = "Digikam" },
      properties = { tag = tags[1][5]} },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "gcolor2" }, 
      properties = { floating = true } },
    { rule = { class = "Gmusicbrowser" },
      properties = { floating = true } },
    -- trying to start Firefox's download window minimized, not working
    { rule = { class = "Firefox", instance = "Download" },
      properties = { floating = true, minimized = true } },
    { rule = { name = "Firefox Preferences" },
      properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Abp" }, -- AdblockPlus
      properties = { floating = true } },
    { rule = { class = "<unknown>" }, -- for fullscreen flash videos
      properties = { floating = true } },
    { rule = { class = "Plugin-container" }, -- for fullscreen flash videos
      properties = { floating = true } }, 
    { rule = { class = "Wine" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { floating = true } },
    { rule = { class = "Hp-toolbox" },
      properties = { floating = true } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][6] },
      callback = awful.client.setslave },
    { rule = { instance = "Chats" },
      properties = { tag = tags[1][6] } },
    { rule = { role = "conversation" },
      properties = { tag = tags[1][6] } },
    { rule = { name = "JDownloader" },
      properties = { tag = tags[1][7] } },
  }

-- {{{ Autorun apps
autorun = true

--- Old way
--autorunApps =
--{
--    "xbindkeys",
--    "compton --config /home/gianluca/.config/compton.conf",
--    "xset m 0.7 2",
--    "xset dpms 0 900 2750",
--    "urxvtd -q -o -f",
--}

--if autorun then
--    for app = 1, #autorunApps do
--        awful.util.spawn(autorunApps[app])
--    end
--end

--- New way
if autorun then
    run_once("xbindkeys")
    run_once("compton", "--config /home/gianluca/.config/compton.conf")
    run_once("xset", "m 0.7 2")
    run_once("xset", "dpms 0 900 2750")
    run_once("urxvtd", "-q -o -f")
    run_once(browser)
end

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- honor size hints
    c.size_hints_honor = false
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- I want Mplayer sticky in all tags
    --if c.name:find("MPlayer") then
    --    for s = 1, screen.count() do
    --        tagtable = screen[s]:tags()
    --        for k,t in pairs(tagtable) do
    --            if t ~= awful.tag.selected() then
    --                awful.client.toggletag(t, c)
    --            end
    --        end
    --    end
    --end
    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("marked", function (c) c.border_color = beautiful.border_marked end)

client.connect_signal("manage", function (c, startup)
	-- if we are not managing this application at startup,
	-- move it to the screen where the mouse is.
	-- we only do it for filtered windows (i.e. no dock, etc).
	if not startup and awful.client.focus.filter(c) then
		c.screen = mouse.screen
	end
end)


-- call coverart_show every 2 seconds
--mpdtimer = timer({ timeout = 2 })
--mpdtimer:connect_signal("timeout", function () coverart_show() end)
--mpdtimer:start()

-- }}}

-- vim: set filetype=lua tabstop=4 shiftwidth=4:
