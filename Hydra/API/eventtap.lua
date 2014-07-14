--- eventtap.new(type, callback) -> event
--- Returns a new event tap with the given callback for the given event type; is not started automatically.
--- The type param must be one of the values from the table `event.eventtaptypes`.
--- If the callback function returns nothing, the event is not modified; if it returns nil, the event is deleted from the OS X event system and not seen by any other apps; all other return values are reserved for future features to this API.
--- The callback usually takes no params, except for certain events:
---   flagschanged: takes a table with any of the strings {"cmd", "alt", "shift", "ctrl", "fn"} as keys pointing to the value `true`
function eventtap.new(typ, fn)
  local t = {typ = typ, fn = fn}
  return setmetatable(t, {__index = eventtap})
end

--- eventtap.postkey(keycode, mods, dir = "both")
--- Sends a keyboard event as if you did it manually.
---   keycode is a numeric value from `hotkey.keycodes`
---   dir is either 'press', 'release', or 'pressrelease'
---   mods is a table with any of: {'ctrl', 'alt', 'cmd', 'shift'}
--- Sometimes this doesn't work inside a hotkey callback for some reason.
local dirs = {press = 1, release = 2, pressrelease = 3}
function eventtap.postkey(mods, key, dir)
  dir = dir or "pressrelease"
  local m = {}
  for _, mod in pairs(mods) do
    m[mod:lower()] = true
  end
  eventtap._postkey(hotkey.keycodes[key], dirs[dir], m.ctrl, m.alt, m.cmd, m.shift)
end
