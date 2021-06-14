local last_ime = 'Chinese'  -- default IME

local lang2sourceid = {
    ['English'] = 'com.apple.keylayout.ABC',
    ['Chinese'] = 'com.apple.inputmethod.SCIM.ITABC',
    -- ['Chinese'] = 'im.rime.inputmethod.Squirrel.Rime'
}

local preset = {
    ['Spotlight'] = 'English',
    ['Code'] = 'English',
    ['Sublime Text'] = 'English',
    ['iTerm2'] = 'English',
    ['Terminal'] = 'English',

    ['Finder'] = 'Chinese',
    ['WeChat'] = 'Chinese',
    ['QQ'] = 'Chinese',
    ['Microsoft OneNote'] = 'Chinese',

    ['loginwindow'] = false,
    ['ScreenSaverEngine'] = false
}

local cache = {}

local function setIme(ime)
    local current_ime = hs.keycodes.currentSourceID()
    if current_ime == lang2sourceid['English'] then
        last_ime = 'English'
    elseif current_ime == lang2sourceid['Chinese'] then
        last_ime = 'Chinese'
    end
    if ime == 'English' then
        hs.keycodes.currentSourceID(lang2sourceid['English'])
    elseif ime == 'Chinese' then
        hs.keycodes.currentSourceID(lang2sourceid['Chinese'])
    end
end

function doAppLaunched(appname)
    if preset[appname] then
        setIme(preset[appname])
        cache[appname] = preset[appname]
        print(appname .. ' -> ' .. preset[appname])
    end
end

function doAppActivated(appname)
    if cache[appname] then
        setIme(cache[appname])
        print("'" .. appname .. "' activated, switching to " .. cache[appname])
    elseif preset[appname] then
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

local before_spolight
hs.window.filter.new('Spotlight'):subscribe(
    {
        [hs.window.filter.hasWindow] = function()
            before_spolight = hs.keycodes.currentSourceID()
            hs.keycodes.currentSourceID(lang2sourceid[preset['Spotlight']])
            print("'Spotlight' activated, switching to " .. preset['Spotlight'])
        end,
        [hs.window.filter.hasNoWindows] = function()
            hs.keycodes.currentSourceID(before_spolight)
            print("'Spotlight' deactivated, reverting to " .. before_spolight)
        end
    }
)

hs.application.watcher.new(function (appname, eventtype, appobj)
    print("app watcher: "..appname.." "..eventtype)
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

hs.caffeinate.watcher.new(function (eventtype)
    if eventtype == hs.caffeinate.watcher.systemDidWake then
        hs.reload()
    end
end):start()
