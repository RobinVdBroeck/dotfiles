#!/bin/sh
nvim --headless +'lua vim.pack.update(nil, { force = true })' +qa
