-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Load LuaRocks if available
pcall(require, "luarocks.loader")

-- Error handling
if awesome.startup_errors then
    naughty.notify({ 
        preset = naughty.config.presets.critical,
        title = "Startup Error!",
        text = awesome.startup_errors 
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ 
            preset = naughty.config.presets.critical,
            title = "Runtime Error!",
            text = tostring(err) 
        })
        in_error = false
    end)
end

-- Variables
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

modkey   = "Mod4"
terminal = "st"
editor   = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle,
}

-- Helper functions
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

-- Wibar Setup
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end)
)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mytaglist   = awful.widget.taglist { screen = s, filter = awful.widget.taglist.filter.all, buttons = taglist_buttons }
    s.mywibox     = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle
        { -- Right
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox.widget.textclock(),
            s.mylayoutbox,
        },
    }
end)

-- Mouse Bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))

-- Key Bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "h", hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),

    -- Client Focus
    awful.key({ modkey }, "j", function () awful.client.focus.byidx( 1) end, {description = "focus next", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end, {description = "focus prev", group = "client"}),
    awful.key({ modkey }, ".", function () awful.screen.focus_relative( 1) end, {description = "focus the next screen", group = "screen"}),
    -- Layout Manipulation
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx( 1) end, {description = "swap next", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end, {description = "swap prev", group = "client"}),
    awful.key({ modkey }, "Tab", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end),

    -- Standard Programs
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end, {description = "open terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "p", function() menubar.show() end, {description = "show the menubar", group = "launcher"}),

    -- Layout selection
    awful.key({ modkey }, "space", function () awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end),

    -- Prompts
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end),

    -- Open apps
    awful.key({ modkey }, "s", function () awful.spawn("firefox") end, {description = "launch firefox", group = "launcher"}),

    -- Volume
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("pamixer -i 4") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn.with_shell("pamixer -d 4") end),

    -- Media Controls (Standard + Requested F11/F12)
    awful.key({ modkey }, "F11", function () awful.spawn.with_shell("playerctl previous") end, {description = "skip back", group = "media"}),
    awful.key({ modkey }, "F12", function () awful.spawn.with_shell("playerctl next") end, {description = "skip forward", group = "media"}),
    awful.key({ }, "XF86AudioPlay", function () awful.spawn.with_shell("playerctl play-pause") end),

    -- Screenshot
    awful.key({}, "Print", function () 
        awful.spawn.with_shell("scrot -s 'screenshot-%Y-%m-%d-%H-%M-%S.png' -e 'xclip -selection clipboard -target image/png -i $f && rm $f'") 
    end, {description = "screenshot to clipboard", group = "screenshot"})
)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen; c:raise() end),
    awful.key({ modkey }, "q", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey }, "o", function (c) c:move_to_screen() end),
    awful.key({ modkey }, "n", function (c) c.minimized = true end),
    awful.key({ modkey }, "m", function (c) c.maximized = not c.maximized; c:raise() end)
)

-- Bind number keys to tags
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end)
    )
end

root.keys(globalkeys)

-- Rules
awful.rules.rules = {
    { rule = { },
      properties = { 
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        titlebars_enabled = false
      }
    },
    -- Gaming rule
    { rule = { class = "gamescope" },
      properties = { floating = true, border_width = 0, fullscreen = true, ontop = true }
    },
    -- Floating windows
    { rule_any = {
        class = { "Arandr", "Blueman-manager", "Gpick", "Sxiv", "Wpa_gui" },
        name = { "Event Tester" }
      }, properties = { floating = true }
    }
}

-- Signals
client.connect_signal("manage", function (c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
