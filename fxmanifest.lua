fx_version 'bodacious'

game 'gta5'

description 'Livraison PrimeV'

client_scripts {
    "src/vMenu.lua",
    "src/menu/ValUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

}

client_scripts {
    'client/*.lua',
    "config.lua"
}

server_scripts {
	"config.lua",
	'server/main.lua'
}