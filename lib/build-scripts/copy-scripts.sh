#!/bin/zsh

# copy-scripts.sh
# Lua
#
# Created by Corey Johnson on 5/27/10.
# Copyright 2009 Probably Interactive. All rights reserved.

WAX_ROOT_DIR=${WAX_ROOT_DIR:-"wax-root"}
WAX_LUA_INIT_SCRIPT=${WAX_LUA_INIT_SCRIPT:-"AppDelegate"}

if [ -d "$PROJECT_DIR/data/scripts" ]; then
	say "WAX ERROR! Read console output for help."

	echo "
The wax file layout has changed, but your project is still using the 
old layout. Here is what you need to do:


1) All the wax scripts are placed in $PROJECT_DIR/$WAX_ROOT_DIR now.
2) mv $PROJECT_DIR/data/scripts to $PROJECT_DIR/$WAX_ROOT_DIR
3) If you have anything else inside of the data dir, move that to $PROJECT_DIR/$WAX_ROOT_DIR
4) Delete the data dir, you don't need that anymore.
	"
	exit(1)
fi

mkdir -p "$PROJECT_DIR/$WAX_ROOT_DIR"

[ ! -f "$PROJECT_DIR/$WAX_ROOT_DIR/$WAX_LUA_INIT_SCRIPT.lua" ] && cat << EOF > "$PROJECT_DIR/$WAX_ROOT_DIR/$WAX_LUA_INIT_SCRIPT.lua"
puts 'You are setup to use wax!' 
puts 'Edit file at $PROJECT_DIR/$WAX_ROOT_DIR/$WAX_LUA_INIT_SCRIPT.lua'
EOF

# copy everything in the wax root dir to the app (doesn't just have to be lua files, can be images, sounds, etc...)
rsync -r --delete "$PROJECT_DIR/$WAX_ROOT_DIR" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null

# copy the wax framework scripts to the application bundle
if [ -d "$PROJECT_DIR/wax.framework" ]; then
  rsync -r --delete "$PROJECT_DIR/wax.framework/resources/wax-scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/wax" > /dev/null
else
  rsync -r --delete "$PROJECT_DIR/wax/lib/wax-scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/wax" > /dev/null
fi

# This forces the data dir to be reloaded on the device
touch "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH"/*

# luac.lua doesn't work for 64 bit lua
# if [[ $CONFIGURATION = "Distribution" ]]; then
#     ${LUA:=/usr/bin/env lua}
#     $LUA "$PROJECT_DIR/wax/build-scripts/luac.lua" init.dat "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/init.lua" -L "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR"/**/*.lua
#     rm -rf "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/"*
#     mv init.dat "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_ROOT_DIR/"
# fi