---- {{{ Requirements

local beautiful = require("beautiful")
local naughty = require("naughty")

---- }}}

---- {{{ Functions

---- Mouse remove function
-- basically move the pointer to the bottom right of the screen with
-- Mod4+Ctrl+m, useful to remove it when it stands in the middle of the
-- screen but without using the touchpad
local safeCoords = {x=800, y=1050}
function moveMouse(x_co, y_co)
    mouse.coords({ x=x_co, y=y_co })
end

--- Simulate mouse click
local function simulateClick()
    root.fake_input("button_press", 1)
    root.fake_input("button_release", 1)
end

---- Markup functions

--- Set background colour
function setBg(bgcolor, text)
    return string.format('<bg color="'..bgcolor..'" />'..text)
end

--- Set foreground colour
function setFg(fgcolor, text)
	return '<span color="' .. fgcolor .. '">' .. text .. '</span>'
end

--- Set background and foreground colours
function setBgFg(bgcolor, fgcolor, text)
    return string.format('<bg color="'..bgcolor..'" /><span color="'..fgcolor'">'..text..'</span>')
end

--- Set a custom font
function setFont(font, text)
    return string.format('<span font_desc="'..font..'">'..text..'</span>')
end

--- Show clipboard contents
function show_clipboard()
    local paste = selection()
    paste = naughty.notify({
        text = paste,
        timeout = 3,
        hover_timeout = 3,
        width = 300,
    })
end

--- Xprop function. It substitutes xprop functionality with a naughty 
--notification
function xprop(c)
    f = function (prop, str)
        return
        prop and
        ( str
        .. ((type(prop)=="boolean") and "" or (" = " .. prop))
        .. "\n"
        )
        or ""
    end

    naughty.notify({
        title = "Client info",
        text = ""
        .. f(c.class, "class")
        .. f(c.instance, "instance")
        .. f(c.name, "name")
        .. f(c.type, "type")
        .. f(c.role, "role")
        .. f(c.pid, "pid")
        .. f(c.window, "window_id")
        .. f(c.machine, "machine")
        .. f(c.floating, "Is floating")
        .. f(c.minimized, "Is minimized")
        .. f(c.fullscreen, "Is fullscreen")
        .. f(c.maximized_horizontal, "Is maximized horizontal")
        .. f(c.maximized_vertical, "Is maximized vertical")
        .. f(c.urgent, "Is urgent")
        .. f(c.focused, "Has focus")
        .. f(c.sticky, "Is sticky")
        .. f(c.ontop, "Is ontop")
        .. f(c.above, "Is set above")
        .. f(c.below, "Is set below")
    })
end

-- Wifi naughty message
function wifiMessage(adapter)
    local f = io.open("cat /sys/class/net/"..adapter.."/wireless/link")
    local wifiStrength = f:read("*a")
    f:close()
    if wifiStrength == "0" then
        naughty.notify({ title = "Wifi message",
            text = "No wireless connectivity!",
            timeout = 3,
            position = "top_right",
            fg = beautiful.fg_focus,
            bg = beautiful.bg_focus
        })
	end
end

-- Wifi signal
function wifiInfo(adapter)
    local f = io.open("/sys/class/net/"..adapter.."/wireless/link")
    local wifiStrength = f:read()
    f:close()


    if wifiStrength == "0" then
        wifiStrength = setFg('#ff6565', wifiStrength) .. "%"
        naughty.notify({ title = "Wifi message",
            text = "No wireless connectivity!",
            timeout = 3,
            position = "top_right",
            fg = beautiful.fg_focus,
            bg = beautiful.bg_focus
        })
    else
        wifiStrength = wifiStrength.."%"
    end
    wifiwidget.text = setFg(beautiful.fg_normal, wifiStrength) 
end

--- Cover art showing function
local coverart_on
local base_id = 0
local m_connection
function coverart_show()
    local id
    local info
    local cover_path
    -- hide a previously showing notify
    coverart_hide()
    -- get song id, info and path to the cover from mpd-popup.lua
    -- if we have already established a connection with the mpd server
    -- before, reuse that
    if m_connection ~= nil then
        m_connection, id, info, cover_path = mpd_main(base_id, m_connection)
    else
        m_connection, id, info, cover_path = mpd_main(base_id)
    end
    -- if the got id is different from the last one, show the naughty
    -- notify
    if id == nil then
        return
    end
    if base_id ~= id then
        local img = image(cover_path)
        local ico = img
        local txt = info
        coverart_on = naughty.notify({
            icon = ico,
            icon_size = 80,
            text = txt,
            timeout = 3,
            position = "bottom_right"
        })
    -- new id becomes the old one
    base_id = id
    end
end

function coverart_hide()
    if coverart_on ~= nil then
        naughty.destroy(coverart_on)
    end
end

---- Temp functions

--- Get Cpu temperature
function getCpuTemp ()
    --local f = io.popen('cut -b 1-2 /sys/module/w83627ehf/drivers/platform\:w83627ehf/w83627ehf.656/temp1_input')
    local f = io.popen('cut -b 1-2 /sys/class/hwmon/hwmon0/device/temp3_input')
	local n = f:read()
	f:close()
    return  setFg(beautiful.fg_normal, ' '..n..'°C')
end

--- Get motherboard chipset temperature
function getMoboTemp ()
  --local f = io.popen('cut -b 1-2 /sys/module/w83627ehf/drivers/platform\:w83627ehf/w83627ehf.656/temp2_input')
  local f = io.popen('cut -b 1-2 /sys/class/hwmon/hwmon0/device/temp1_input')
  local n = f:read()
  f:close()
  return setFg(beautiful.fg_normal, ' '..n..'°C ')
end

--- Get Gpu (nvidia) temperature
function getGpuTemp ()
    --local f = io.popen(home .. "/.conky/nvidiatemp")
	local f = io.popen('nvidia-settings -q gpucoretemp -t')
	local n = f:read()
	f:close()
    if (n == nil) then
        return ''
    end
    if tonumber(n) >= 70 then
        n = setFg("#aadc43", n .. '°C')
        return n
    else
	    return setFg(beautiful.fg_normal, n..'°C ')
    end
end

-- Get temp of /dev/sda hard disk (via hddtemp)
function getSdaTemp ()
	local f = io.popen("sudo hddtemp /dev/sda | awk '{print $4}'")
	local n = f:read()
	f:close()
	return setFg(beautiful.fg_normal, ' '..n..'°C ')
end

---- Calendar functions
-- One to show the current month's calendar, another to destroy the 
-- notification
local calendar = nil
local offset = 0

function removeCalendar()
    if calendar ~= nil then
        naughty.destroy(calendar)
        calendar = nil
        offset = 0
    end
end

function addCalendar(inc_offset)
    local save_offset = offset
    removeCalendar()
    offset = save_offset + inc_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local cal = awful.util.pread("cal -m " .. datespec)
    cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
    calendar = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "monospace", os.date("%a, %d %B %Y") .. "\n" .. cal),
        timeout = 0,
        hover_timeout = 0.5,
        width = 150,
        position = "bottom_right",
    })
end

-- Battery level
function batteryInfo(adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    fcur:close()
    local cap = fcap:read()
    fcap:close()
    local sta = fsta:read()
    fsta:close()

    local battery = math.floor(cur * 100 / cap)

    if sta:match("Charging") then
        dir = "^"
        battery = battery.."%"..dir
    elseif sta:match("Discharging") then
        dir = "v"
        --battery  = dir..battery.."%"..dir
        if tonumber(battery) >= 25 and tonumber(battery) <= 50 then
            local battery_perc = battery.."%"..dir
            battery = setFg("#e6d51d", battery_perc)
        elseif tonumber(battery) < 25 then
            if tonumber(battery) <= 5 then
                naughty.notify({ title = "Battery Warning",
                    text = "Battery low!"..spacer..battery.."%"..spacer.."left!",
                    timeout = 5,
                    position = "top_right",
                    fg = beautiful.fg_focus,
                    bg = beautiful.bg_focus
                })
            end
            local battery_perc = battery.."%"..dir
            battery = setFg("#ff6565", battery)
        end
    else
        dir = "="
        battery = "AC"..dir
    end

    batterywidget.text = spacer..setFg(beautiful.fg_normal, battery)
end
--- Show the 15 processes occupying the most the cpu in a naughty 
--notification
function psByCpu(n)
    if n == 1 then
        naughty.destroy(cpuPopup)
        cpuPopup = nil
    else
        local r = io.popen("ps -eo pid,user,comm,%cpu --sort=-%cpu | sed -n '1,15p'"):read("*a")
        cpuPopup = naughty.notify({
            title = "Cpu Usage",
            text = r,
            timeout = 0,
            hover_timeout = 3,
            width = 250
        })
    end
end

--- Show the 15 processes using the most memory in a naughty 
--notification
function psByMemory(n)
    if n == 1 then
        naughty.destroy(memoryPopup)
        memoryPopup = nil
    else
        -- memory sorting doesn't work
        local r = io.popen("ps -eo pid,pmem,user,comm,rss --sort -rss | sed -n '1,15p'"):read("*a")
        memoryPopup = naughty.notify({
            title = "Memory Usage",
            text = r,
            timeout = 0,
            hover_timeout = 3
        })
    end
end

--- Notification of one's daily schedule
function dailySchedule()
    local r = [[ ]] -- a stringified list of time and corresponding activity throughout the day.
					-- Fill it with your schedule
    roadmapPopup = naughty.notify({
        title = "Daily Activities",
        text = r,
        timeout = 3,
        hover_timeout = 3,
    })
end

--- Show taskwarrior tasks in a very minimal fashion
function taskShow()
    local t = io.popen("task veryminimal"):read("*a")
    taskPopup = naughty.notify({
        title = "Tasks",
        text = t,
        timeout = 3,
        hover_timeout = 3,
        position = "bottom_right"
    })
end

-- Gmail function
function getGmailUnread()
    -- check if the network is up by pinging the router
    local eth0up = os.execute("ping -c 1 192.168.0.1")
    if eth0up == nil then
        -- if no connection available, return 0 
        return spacer .. '0/0'
    else
        local unread = io.popen(home .. "/Script/imap_check.py")
        local f = unread:read()
        unread:close()
        return spacer .. setFg(beautiful.fg_normal, f)
    end
end

-- And the function to read the temporary file
function runGmailCheck()
    os.execute(home .. "/Script/imap_check.py > /tmp/gmailcheck &")
end

-- Show currently playing song in moc
function mocMessage(n)
	if n == 1 then
		naughty.destroy(message)
		message = nil
	else
		local i = io.popen("mocp --info"):read("*a")

		message = naughty.notify({
			title = "Now Playing",
			text = i,
			timeout = 0,
			hover_timeout = 1
		})
	end
end

---- }}}

-- vim: set filetype=lua tabstop=4 shiftwidth=4:
