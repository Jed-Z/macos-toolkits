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
        hs.keycodes.currentSourceID('im.rime.inputmethod.Squirrel.Rime')
    end
end

local appname2ime = {}
appname2ime['Code'] = 'English'
appname2ime['Sublime Text'] = 'English'
appname2ime['iTerm2'] = 'English'
appname2ime['Terminal'] = 'English'

appname2ime['Finder'] = 'Chinese'
appname2ime['WeChat'] = 'Chinese'
appname2ime['QQ'] = 'Chinese'
appname2ime['Microsoft OneNote'] = 'Chinese'

local cache = {}

function doAppLaunched(appname)
    if appname2ime[appname] ~= nil then
        setIme(appname2ime[appname])
        cache[appname] = appname2ime[appname]
        print(appname .. ' -> ' .. appname2ime[appname])
    end
end

function doAppActivated(appname)
    if cache[appname] ~= nil then
        setIme(cache[appname])
        print("'" .. appname .. "' activated, switching to " .. cache[appname])
    elseif appname2ime[appname] ~= nil then
        setIme(appname2ime[appname])
        print("'" .. appname .. "' activated (cache miss), switching to " .. appname2ime[appname])
    else
        print("'" .. appname .. "' activated, doing nothing")
    end
end

function doAppDeactivated(appname)
    cache[appname] = last_ime
    print("'" .. appname .. "' deactivated")
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
