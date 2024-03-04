ScriptBase.registerCallback('fpm:scriptbase-test:cb:client@server', function(player, data1, data2)
    print("received data: ", data1, data2)
    ScriptBase.callback(player, 'fpm:scriptbase-test:cb:server@client', data1, data2):async(function(...)
        print("callback (async):", ...)
    end)
    return data2, data1
end)