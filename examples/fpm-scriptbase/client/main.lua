ScriptBase.registerCallback('fpm:scriptbase-test:cb:server@client', function(data1, data2)
    print("received data: ", data1, data2)
    return data2, data1
end)

Wait(1000)

print("callback result (sync):", ScriptBase.callback('fpm:scriptbase-test:cb:client@server', "data1", "data2"):sync())

ScriptBase.callback('fpm:scriptbase-test:cb:client@server', "data1", "data2"):async(function(...)
    print("callback (async): ", ...)
end)