#!/bin/sh
luafmt -l init.lua -w replace init.lua
for FILE in $(find lua/ -type f -name '*.lua')
do
    echo $FILE
    luafmt -l "$FILE" -w replace "$FILE"
done 

