fx_version 'cerulean'
game 'gta5'

name 'fpm_hud'
description 'generated with fiveM project manager'
author 'java3east'
version '1.0'

shared_scripts {
    'config.lua',
    'open.lua',
    'shared/modules/debug/debug.lua',
    'shared/modules/class/class.lua',
    'shared/modules/framework/account/fpmAccount.lua',
    'shared/modules/framework/sex/sex.lua',
}

client_scripts {
    'client/modules/ui/ui.lua',
    'client/modules/framework/frameworks/custom.lua',
    'client/modules/framework/frameworks/esx.lua',
    'client/modules/framework/frameworks/qb.lua',
    'client/main.lua'
}

server_scripts {
    'server/modules/framework/player/offlinePlayer.lua',
    'server/modules/framework/player/player.lua',
    'server/modules/framework/frameworks/custom.lua',
    'server/modules/framework/frameworks/esx.lua',
    'server/modules/framework/frameworks/qb.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
    'ui/ui/assets/*.*'
}
