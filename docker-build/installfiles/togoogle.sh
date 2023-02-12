#!/bin/bash

set_server_env(){
    if [ -z ${TOGOOGLE_SERVERIP} ]; then
        SERVERIP='1.1.1.1'
    else
        SERVERIP=${TOGOOGLE_SERVERIP}
    fi

    if [ -z ${TOGOOGLE_SERVERPORT} ]; then
        BROOK_PORT='1111'
        V2RAY_PORT='2222'
    else
        BROOK_PORT=${TOGOOGLE_SERVERPORT}
        V2RAY_PORT=${TOGOOGLE_SERVERPORT}
    fi

    if [ -z ${TOGOOGLE_PASSWORD} ]; then
        BROOK_PASSWORD='password'
        V2RAY_USERID='uuid'
    else
        BROOK_PASSWORD=${TOGOOGLE_PASSWORD}
        V2RAY_USERID=${TOGOOGLE_PASSWORD}
    fi
}

set_proxy(){
    export http_proxy='socks5://127.0.0.1:1080'
    export https_proxy='socks5://127.0.0.1:1080'
}

unset_proxy(){
    unset http_proxy
    unset https_proxy
}

run_brook(){
    /opt/brook client --socks5="0.0.0.0:1080" -s ${SERVERIP}:${BROOK_PORT} -p ${BROOK_PASSWORD} &
}

run_v2ray(){
    sed -e "s/SERVERIP/${SERVERIP}/" -e "s/V2RAY_PORT/${V2RAY_PORT}/" -e "s/V2RAY_USERID/${V2RAY_USERID}/" /opt/v2ray/config.json > /opt/v2ray/tmp_run_config.json
    /opt/v2ray/v2ray run -c /opt/v2ray/tmp_run_config.json &
}

run_something(){
    if [ $1 == 'brook' ]; then
        run_brook
    elif [ $1 == 'v2ray' ]; then
        run_v2ray
    fi    
}

stop_something(){
    ps -ef|grep $1 | sed -n '1p' | awk '{print $2}' | xargs kill -9
    unset http_proxy
    unset https_proxy
}

operation_something(){
if [ $# -eq 2 ]; then
    if [ $1 == 'start' ] || [ $1 == 'run' ]; then
        run_something $2
        set_proxy
    elif [ $1 == 'stop' ] || [ $1 == 'kill' ]; then
        stop_something $2
        unset_proxy
    elif [ $1 == 'restart' ]; then
        unset_proxy
        stop_something $2
        run_something $2
        set_proxy
    fi
fi
}

set_server_env

if [ $# -ge 2 ]; then
    operation_something $1 $2
elif [ $# -eq 1 ]; then
    operation_something $1 brook
elif [ $# -eq 0 ]; then
    operation_something run brook
fi
