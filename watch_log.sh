#!/bin/bash

# env=production
env=development

lines=20
filename=./log/$env.log

clear

tail --follow --lines $lines $filename

# REM Work is only BASH!

# REM SET Env=production
# SET Env=development

# SET Lines=20

# TITLE WATCH -%Env%-

# @ECHO ON

# CLEAR

# REM tail --follow --lines 20 %FileName%
