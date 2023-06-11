#!/bin/sh

if ! type stylua >>/dev/null; then
    echo "stylua not found"
    exit 1
fi

stylua init.lua
for FILE in $(find lua/ -type f -name '*.lua')
do
    stylua $FILE
done 

