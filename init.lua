last_ime = 'Chinese'

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
appname2ime['Visual Studio Code'] = 'English'
appname2ime['Sublime Text'] = 'English'
appname2ime['Finder'] = 'Chinese'

local cache = {}

function setCache(key, value)
    if value ~= nil then
        print("SET cache[" .. key .. "]=" .. value)
    else
        print("SET cache[" .. key .. "]=nil")
    end
    cache[key] = value
end

-- 按下Ctrl+Command+.时会显示当前应用的路径、名称和当前输入法
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        " .. hs.window.focusedWindow():application():path() .. "\n"
    .. "App name:      " .. hs.window.focusedWindow():application():name() .. "\n"
    .. "IM source id:  " .. hs.keycodes.currentSourceID())
    print("----------")
    for k, v in pairs(cache) do
        print("cache[" .. k .. "] = " .. v)
    end
    print("----------")
end)

appWatcher = hs.application.watcher.new(function (appname, eventtype, appobj)
    if eventtype == hs.application.watcher.launched then
        if appname2ime[appname] ~= nil then
            setIme(appname2ime[appname])
            cache[appname] = appname2ime[appname]
            print(appname .. ' -> ' .. appname2ime[appname])
        end
    elseif eventtype == hs.application.watcher.activated then
        print("ACTIVATED : " .. appname .. " @" .. os.clock())
        if cache[appname] ~= nil then
            setIme(cache[appname])
        end
    elseif eventtype == hs.application.watcher.deactivated then
        print("DEACTIVATED : " .. appname .. " @" .. os.clock())
        setCache(appname, last_ime)
    elseif eventtype == hs.application.watcher.terminated then
        setCache(appname, nil)
    end
end)
appWatcher:start()

print('\n')
