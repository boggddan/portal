#!/bin/bash

# Количество строк
lines=10

# В переменную записывем с файла "env" активный режим
env=$(<env)

title="[${PWD##*/}] -$env.log-"

# Заголовок терминала
echo -e "\033]0;$title\a"

# Очистка терминала, аналог "clear"
echo -e '\0033\0143'

tail --follow --lines $lines ./log/$env.log
