fx_version 'cerulean'
game 'gta5'

name "fpm-scriptbase"
description "A test for the fpm script base"
author "Java3east"
version "1.0.0"

shared_scripts {
	'modules/script-base/config.lua',
	'modules/script-base/open.lua',
	'modules/script-base/shared/class.lua',
	'modules/script-base/shared/action.lua',
	'modules/script-base/shared/scriptBase.lua',
	'modules/script-base/shared/**/*',
	'shared/*.lua',
}

client_scripts {
	'modules/script-base/client/scriptBase.lua',
	'client/main.lua',
}

server_scripts {
	'modules/script-base/server/scriptBase.lua',
	'server/main.lua'
}
