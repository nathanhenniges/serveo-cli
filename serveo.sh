#!/bin/bash
SERVEO_HOST=${SERVEO_HOST:-'serveo.net'}

if [ "$1" == "https" ] || [ "$1" == "http" ]
then
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your subdomain? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            ssh -R $3:443:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        ssh -R 443:localhost:$2 `echo -n $(date) | md5sum | cut -c1-8`@$SERVEO_HOST
        echo -e "__________________________________________________                             ";
    fi
elif [[ $1 == 'tcp' ]]
then
    
    if [[ "$3" != '' ]]; then
        read -p "serveo: Are you sure you want to use ${3} as your tcp port? " verify
        if [[ $verify == 'y' || $verify == 'yes' || $verify == 'Y' ]]; then
            ssh -R $3:localhost:$2 $SERVEO_HOST
        else
            echo "serveo: Quiting..."
            sleep 2
            exit 1
        fi
    else
        ssh -R 0:localhost:$2 $SERVEO_HOST
    fi
else
    echo "serveo: $(tput setaf 1)error:$(tput sgr0) Usage:"
    echo "serveo http/https <subdomain> $(tput setaf 1)or$(tput sgr0) serveo tcp <port>"
    exit 1
    echo -e "__________________________________________________                             ";
fi

# if [[ "$1" = 'https' ]]; then
#
# if [[ $3 = 'change' ]]; then
# ssh -R 443:localhost:$2 `echo -n $(date) | md5sum | cut -c1-8`@$SERVEO_HOST
# elif [[ "$3" -gt "1" ]]; then
# ssh -R $3:localhost:$2 $SERVEO_HOST
# else [[ $3 = 0 ]];
# ssh -R 443:localhost:$2 $SERVEO_HOST
# fi
# echo -e "__________________________________________________                             ";
# fi
#
# if [[ "$1" = 'tcp' ]]; then
#
# if [[ "$3" -gt "1" ]]; then
# ssh -R $3:localhost:$2 $SERVEO_HOST
# else [[ $3 = 0 ]];
# ssh -R 0:localhost:$2 $SERVEO_HOST
# fi
# echo -e "__________________________________________________                             ";
# fi