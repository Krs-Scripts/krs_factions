fx_version "cerulean"
use_fxv2_oal "yes"
lua54 "yes"
game "gta5"
version "1.0.0"
description "A simple factions system"
name 'krs_factions'
author "karos7804"

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

dependencies {
    'ox_lib',
    'es_extended',
    'ox_inventory',
    'illenium-appearance',
    'fivem-appearance',
    'gridsystem',
}