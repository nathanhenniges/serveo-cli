#!/bin/bash
SERVEO_HOST=${SERVEO_HOST:-'serveo.net'}


function to_int {
    local -i num="10#${1}"
    echo "${num}"
}

function port_is_ok {
    local port="$1"
    local -i port_num=$(to_int "${port}" 2>/dev/null)
    
    if (( $port_num < 1 || $port_num > 65535 )) ; then
        echo "${port} is not a valid port." 1>&2
        exit 0
    fi
}

if [ "$1" == "https" ] || [ "$1" == "http" ]
then
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your subdomain? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            port_is_ok $2
            ssh -R $3:443:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        port_is_ok $2
        ssh -R 443:localhost:$2 `echo -n $(date) | md5sum | cut -c1-8`@$SERVEO_HOST
        echo -e "__________________________________________________                             ";
    fi
elif [[ $1 == 'tcp' ]]
then
    
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your tcp port? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            port_is_ok $3
            ssh -R $3:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        port_is_ok $2
        ssh -R 0:localhost:$2 $SERVEO_HOST
    fi
else
    echo "serveo: $(tput setaf 1)error:$(tput sgr0) Usage:"
    echo "serveo http/https <subdomain> $(tput setaf 1)or$(tput sgr0) serveo tcp <port>"
    exit 1
    echo -e "__________________________________________________                             ";
fi