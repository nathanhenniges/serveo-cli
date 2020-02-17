#!/bin/bash

clear;
echo -e "__________________________________________________                             ";
echo -e '     __   ___  __        ___  __         ___ ___                               ';
echo -e '    /__` |__  |__) \  / |__  /  \  |\ | |__   |                                ';
echo -e '    .__/ |___ |  \  \/  |___ \__/ .| \| |___  |                                ';
echo -e "__________________________________________________                             ";
echo -e "                                                                               ";
echo -e "  parameter [option] : 0 = request random port                                 ";
echo -e "  parameter [option] [option]: change = Make a random sub domain or choose one.";
echo -e "  parameter [option] [option] [option]: 4869 = Pick your port to foward"        ;
echo -e "                                                                               ";

if [[ "$1" = 'https' ]]; then
    
    if [[ $3 = 'change' ]]; then
        ssh -R 443:localhost:$2 `echo -n $(date) | md5sum | cut -c1-8`@$SERVEO_HOST
        elif [[ "$3" -gt "1" ]]; then
        ssh -R $3:localhost:$2 $SERVEO_HOST
    else [[ $3 = 0 ]];
        ssh -R 443:localhost:$2 $SERVEO_HOST
    fi
    echo -e "__________________________________________________                             ";
fi

if [[ "$1" = 'tcp' ]]; then
    
    if [[ "$3" -gt "1" ]]; then
        ssh -R $3:localhost:$2 $SERVEO_HOST
    else [[ $3 = 0 ]];
        ssh -R 0:localhost:$2 $SERVEO_HOST
    fi
    echo -e "__________________________________________________                             ";
fi