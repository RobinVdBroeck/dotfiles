#!/bin/sh
lua-format -i init.lua 
for FILE in $(find lua/ -type f -name '*.lua')
do
    echo $FILE
    lua-format -i "$FILE" 
done 

