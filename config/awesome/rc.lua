-- ===================================================================
-- CUSTOM VARIABLES (AwesomeWM equivalent)
-- ===================================================================
-- 'Mod4' is the Super/Windows key by default in AwesomeWM
local modkey = "Mod4" 
local altkey = "Mod1" -- Mod1 is the Alt key
local terminal = "st"
local flameshot_save_cmd = "sh -c 'flameshot gui -p ~/Pictures/Screenshots/screenshot_$(date +%s).png'"

-- ===================================================================
-- CUSTOM FUNCTIONS
-- ===================================================================

-- Function to unminimize all windows in the current tag (Qtile 'u' equivalent)
local function unminimize_all_windows()
    local t = awful.screen.focused().selected_tag
    if t then
        for _, c in ipairs(t:clients()) do
            if c.minimized then
                c.minimized = false
            end
        end
    end
end

-- Function to set wallpaper and start daemon (Qtile @hook.subscribe.startup_once equivalent)
-- This replaces your Python autostart() function. Place this at the bottom of rc.lua.
awful.spawn.with_shell("feh --bg-fill /home/tom/mySystem/config/wallpaper.jpg &")
awful.spawn.with_shell("flameshot &")

-- ===================================================================
-- KEYBINDINGS (AwesomeWM Translation)
-- ===================================================================

-- AwesomeWM uses two main tables for keys: 
-- 1. awful.keyboard.append_global_keybindings({...}) for WM commands, media keys, etc.
-- 2. awful.keyboard.append_client_keybindings({...}) for actions on the focused client.
-- I've consolidated most of your Qtile keys into the global table for simplicity.

-- Global AwesomeWM Keys
awful.keyboard.append_global_keybindings({
    -- Window Focus Movement (mod + j/k/l/i)
    awful.key({ modkey }, "j", function () awful.client.focus.byidx( 1) end, 
        {description = "Move focus down", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end, 
        {description = "Move focus up", group = "client"}),
    awful.key({ modkey }, "h", function () awful.tag.viewnext() end, 
        {description = "view next tag", group = "tag"}), -- Replaced Qtile 'j' (left)
    awful.key({ modkey }, "l", function () awful.tag.viewprev() end, 
        {description = "view previous tag", group = "tag"}), -- Replaced Qtile 'l' (right)
    awful.key({ modkey }, "space", function () awful.client.focus.history.previous() end, 
        {description = "Move window focus to other window", group = "client"}),

    -- Window Manipulation / Shuffle (mod + shift + j/k/l/i)
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx( 1) end, 
        {description = "Swap client with next", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end, 
        {description = "Swap client with previous", group = "client"}),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.with_direction("left") end, 
        {description = "Move window to the left", group = "client"}), -- Replaced Qtile 'j' (left)
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.with_direction("right") end, 
        {description = "Move window to the right", group = "client"}), -- Replaced Qtile 'l' (right)

    -- Grow/Shrink (mod + control + j/k/l/i)
    awful.key({ modkey, "Control" }, "j", function () awful.tag.incmwfact(-0.05) end,
        {description = "Grow window down", group = "layout"}),
    awful.key({ modkey, "Control" }, "k", function () awful.tag.incmwfact( 0.05) end,
        {description = "Grow window up", group = "layout"}),
    awful.key({ modkey, "Control" }, "l", function () awful.client.setwfact( 0.05) end,
        {description = "Grow window right", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function () awful.client.setwfact(-0.05) end,
        {description = "Grow window left", group = "layout"}),
    awful.key({ modkey }, "n", function () awful.tag.setmwfact(0.5) end, 
        {description = "Reset all window sizes", group = "layout"}),

    -- Minimize/Unminimize (mod + m/u)
    awful.key({ modkey }, "m", function (c) c.minimized = true end, 
        {description = "Minimize focused window", group = "client"}),
    awful.key({ modkey }, "u", unminimize_all_windows, 
        {description = "Unminimize all windows", group = "client"}),

    -- Screen/Monitor Focus (mod + period/comma)
    awful.key({ modkey }, "period", function () awful.screen.focus_relative( 1) end, 
        {description = "Focus next monitor", group = "screen"}),
    awful.key({ modkey }, "comma",  function () awful.screen.focus_relative(-1) end, 
        {description = "Focus previous monitor", group = "screen"}),

    -- Move Window to Screen (mod + shift + period/comma)
    awful.key({ modkey, "Shift" }, "period", function () awful.client.movetoscreen(awful.screen.focus_relative( 1)) end,
        {description = "Move window to next monitor", group = "client"}),
    awful.key({ modkey, "Shift" }, "comma",  function () awful.client.movetoscreen(awful.screen.focus_relative(-1)) end,
        {description = "Move window to previous monitor", group = "client"}),

    -- Media Keys (Needs a key grabber like 'spectrwm' if AwesomeWM doesn't catch them)
    awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn("pamixer -i 4") end, {description = "Raise volume"}),
    awful.key({}, "XF86AudioLowerVolume", function () awful.spawn("pamixer -d 4") end, {description = "Lower volume"}),
    awful.key({}, "XF86AudioPrev", function () awful.spawn("playerctl previous") end, {description = "Previous track"}),
    awful.key({}, "XF86AudioNext", function () awful.spawn("playerctl next") end, {description = "Next track"}),
    awful.key({}, "XF86AudioPlay", function () awful.spawn("playerctl play-pause") end, {description = "Play/Pause"}),

    -- Launchers (mod + d/f/s)
    awful.key({ modkey }, "d", function () awful.spawn("rofi -show drun") end, {description = "Launch Rofi", group = "launch"}),
    awful.key({ modkey }, "f", function () awful.spawn("firefox") end, {description = "Launch Firefox", group = "launch"}),
    awful.key({ modkey }, "s", function () awful.spawn("spotify") end, {description = "Launch Spotify", group = "launch"}),

    -- Screenshots (flameshot - must be running the daemon)
    awful.key({ "Control" }, "Print", function () awful.spawn("flameshot gui -c") end,
        {description = "Copy selected area screenshot to clipboard (Ctrl+Print)", group = "screenshot"}),
    awful.key({ modkey }, "Print", function () awful.spawn(flameshot_save_cmd) end,
        {description = "Save a screenshot of a selected area to Pictures (Mod+Print)", group = "screenshot"}),
    awful.key({ "Shift" }, "Print", function () awful.spawn("flameshot gui -c") end,
        {description = "Copy screenshot to clipboard (Shift+Print)", group = "screenshot"}),

    -- WM Controls
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end, {description = "Launch terminal", group = "launcher"}),
    awful.key({ modkey }, "Tab", function () awful.layout.inc( 1) end, {description = "Toggle between layouts", group = "layout"}),
    awful.key({ modkey, "Control" }, "f", function (c) c.fullscreen = not c.fullscreen end, {description = "Toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "t", function (c) c.floating = not c.floating end, {description = "Toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart, {description = "Reload the config", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit, {description = "Shutdown AwesomeWM", group = "awesome"}),
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end, {description = "Spawn a command using a prompt widget", group = "launcher"}),
})

-- Client (Window) Specific Keys
awful.keyboard.append_client_keybindings({
    awful.key({ modkey }, "q", function (c) c:kill() end, {description = "Kill focused window", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function (c) c:toggle_split() end, {description = "Toggle between split and unsplit sides of stack", group = "layout"}),
})

-- Tag (Group) Keys
-- Tag switching: mod + number
for i = 1, 9 do
    awful.key({ modkey }, "#" .. i + 9,
              function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                       tag:view_only()
                    end
              end,
              {description = "view tag #"..i, group = "tag"}),
end

-- Move window to tag and switch: alt + number (from your Qtile config)
for i = 1, 9 do
    awful.key({ altkey }, "#" .. i + 9,
              function ()
                  if client.focus then
                      local tag = client.focus.screen.tags[i]
                      if tag then
                          client.focus:move_to_tag(tag)
                          tag:view_only()
                      end
                   end
              end,
              {description = "move focused client to tag #"..i, group = "tag"}),
end

-- Mouse bindings are handled by the 'mousegrabber' in AwesomeWM, not explicitly in this table.
-- Your Qtile mouse bindings are standard and should be found in a default rc.lua.
