-----------------------------------------------------------------------------------------------------------------------
--                                                Colorless config                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Load modules
-----------------------------------------------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("awful.autofocus")

-- User modules
------------------------------------------------------------
local redflat = require("redflat")
local newflat = require("newflat")
-- global module
-- timestamp = require("redflat.timestamp")
-- debug locker
local lock = lock or {}

redflat.startup.locked = lock.autostart
redflat.startup:activate()

-- Error handling
-----------------------------------------------------------------------------------------------------------------------
require("colorless.ercheck-config") -- load file with error handling


-- Setup theme and environment vars
-----------------------------------------------------------------------------------------------------------------------
local env = require("colorless.env-config") -- load file with environment
env:init({ theme = "colorless" })


-- Layouts setup
-----------------------------------------------------------------------------------------------------------------------
local layouts = require("colorless.layout-config") -- load file with tile layouts setup
layouts:init()


-- Main menu configuration
-----------------------------------------------------------------------------------------------------------------------
local mymenu = require("colorless.menu-config") -- load file with menu configuration
mymenu:init({ env = env })


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- Separator
--------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	--awful.button({}, 2, redflat.widget.tasklist.action.close), -- commented for locate-pointer program
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
awful.button({         }, 1, function(t) t:view_only() end),
awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
awful.button({         }, 2, awful.tag.viewtoggle),
awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock({ timeformat = "%H:%M", dateformat = "%b  %d  %a" })

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
awful.button({ }, 1, function () awful.layout.inc( 1) end),
awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end),
awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Tray widget
--------------------------------------------------------------------------------
-- local tray = {}
-- tray.widget = redflat.widget.minitray()
--
-- tray.buttons = awful.util.table.join(
-- 	awful.button({}, 1, function() awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end)
-- )




-- Toppanel
-----------------------------------------------------------------------------------
local toppanel = require("colorless.top-panel")
toppanel:init({ env = env })

--------------

-- Exit screen
----------------------------------------------------------------------------------
require('colorless.exit-screen')

-- Sceeenshot
----------------------------------------------------------------------------------
require("colorless.scripts.screenshot")


-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = require("colorless.keys-config") -- load file with hotkeys configuration
hotkeys:init({ env = env, menu = mymenu.mainmenu })


-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require("colorless.rules-config") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})


-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require("colorless.titlebar-config") -- load file with titlebar configuration
titlebar:init()

-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require("colorless.signals-config") -- load file with signals configuration
signals:init({ env = env })


-- Change screen focus indicator
-----------------------------------------------------------------------------------------------------------------------
timer {
    timeout   = 0.1,
    call_now  = true,
    autostart = true,
    callback  = function()
        screen.emit_signal("request::activate", "screen-switch", {raise = true})
    end
}
-- Autostart user applications
-----------------------------------------------------------------------------------------------------------------------
local autostart = require("colorless.autostart-config") -- load file with autostart application list

-- Autostart user applications
-----------------------------------------------------------------------------------------------------------------------
if redflat.startup.is_startup then
	local autostart = require("colorless.autostart-config") -- load file with autostart application list
	autostart.run()
end
