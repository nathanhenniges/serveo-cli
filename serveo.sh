#!/bin/bash
# MIT License

# Copyright (c) 2020 Nathan Henniges

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


SERVEO_HOST=${SERVEO_HOST:-'serveo.net'}

function to_int {
    local -i num="10#${1}"
    echo "${num}"
}

function port_is_ok {
    local port="$1"
    local -i port_num=$(to_int "${port}" 2>/dev/null)
    
    if [[ "$port" == '' ]]; then
        echo 'Port is required to use serveo'
        echo "Usage: serveo http/https <subdomain> $(tput setaf 1)or$(tput sgr0) serveo tcp <port>"
        exit 1
    fi
    
    if (( $port_num < 1 || $port_num > 65535 )) ; then
        echo "${port} is not a valid port." 1>&2
        exit 1
    fi
}

if [ -z "$1" ]; then
    echo "Usage: serveo http/https <subdomain> $(tput setaf 1)or$(tput sgr0) serveo tcp <port>"
    exit 0
fi

if [ "$1" == "https" ] || [ "$1" == "http" ]
then
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your subdomain? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            port_is_ok $2
            ssh -o LogLevel=QUIET -R $3:443:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        port_is_ok $2
        ssh -o LogLevel=QUIET -R 443:localhost:$2 `echo -n $(date) | md5sum | cut -c1-12`@$SERVEO_HOST
    fi
elif [[ $1 == 'tcp' ]]
then
    
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your tcp port? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            port_is_ok $3
            ssh -o LogLevel=QUIET -R $3:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        port_is_ok $2
        ssh -o LogLevel=QUIET -R 0:localhost:$2 $SERVEO_HOST
    fi
else
    echo "Usage: serveo http/https <subdomain> $(tput setaf 1)or$(tput sgr0) serveo tcp <port>"
    echo -e "__________________________________________________                             ";
    exit 1
fi
