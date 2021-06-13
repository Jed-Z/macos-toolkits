local last_ime = 'Chinese'

local function setIme(ime)
    local current_ime = hs.keycodes.currentSourceID()
    if current_ime == 'com.apple.keylayout.ABC' then
        last_ime = 'English'
    elseif current_ime == 'im.rime.inputmethod.Squirrel.Rime' then
        last_ime = 'Chinese'
    end

    if ime == 'English' then
        hs.keycodes.currentSourceID('com.apple.keylayout.ABC')
    elseif ime == 'Chinese' then
        -- hs.keycodes.currentSourceID('im.rime.inputmethod.Squirrel.Rime')
        hs.keycodes.currentSourceID('com.apple.inputmethod.SCIM.ITABC')
    end
end

local preset = {}
preset['Code'] = 'English'
preset['Sublime Text'] = 'English'
preset['iTerm2'] = 'English'
preset['Terminal'] = 'English'
preset['Finder'] = 'Chinese'
preset['WeChat'] = 'Chinese'
preset['QQ'] = 'Chinese'
preset['Microsoft OneNote'] = 'Chinese'

local cache = {}

function doAppLaunched(appname)
    if preset[appname] ~= nil then
        setIme(preset[appname])
        cache[appname] = preset[appname]
        print(appname .. ' -> ' .. preset[appname])
    end
end

function doAppActivated(appname)
    if cache[appname] ~= nil then
        setIme(cache[appname])
        print("'" .. appname .. "' activated, switching to " .. cache[appname])
    elseif preset[appname] ~= nil then
        setIme(preset[appname])
        print("'" .. appname .. "' activated (cache miss), switching to " .. preset[appname])
    else
        print("'" .. appname .. "' activated, doing nothing")
    end
end

function doAppDeactivated(appname)
    cache[appname] = last_ime
    print("'" .. appname .. "' deactivated, " .. "setting cache['" .. appname .. "'] = " .. last_ime)
end

function doAppTerminated(appname)
    cache[appname] = nil
    print("'" .. appname .. "' terminated, " ..  "removing cache['" .. appname .. "']")
end

-- 按下Ctrl+Command+.时会显示当前应用的路径、名称和当前输入法
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        " .. hs.window.focusedWindow():application():path() .. "\n"
        .. "App name:      " .. hs.window.focusedWindow():application():name() .. "\n"
        .. "IM source id:  " .. hs.keycodes.currentSourceID())
    print("----------")
    for k, v in pairs(cache) do
        print("cache['" .. k .. "'] = " .. v)
    end
    print("----------")
end)

hs.application.watcher.new(function (appname, eventtype, appobj)
    if eventtype == hs.application.watcher.launched then
        doAppLaunched(appname)
    elseif eventtype == hs.application.watcher.activated then
        doAppActivated(appname)
    elseif eventtype == hs.application.watcher.deactivated then
        doAppDeactivated(appname)
    elseif eventtype == hs.application.watcher.terminated then
        doAppTerminated(appname)
    end
end):start()
print('======= RESTARTING =======')
