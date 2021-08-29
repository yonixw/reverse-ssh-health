#!/bin/bash -xv

log () {
  echo "[$(date -Iseconds)Z] $1"
}

while true
do  
  log 'Cheking for ssh'
  ps -e -o args | grep '[S]erverAliveInterval'
  if [ $? -ne 0 ]
  then
   log 'Starting SSH reverse ...'
   ssh -N -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=$SSH_KEEPALIVE $SSH_ARGS &
  fi

  log 'Cheking for socat'
  ps -e -o args | grep '[s]ocat tcp-l'
  if [ $? -ne 0 ]
  then
   log 'Starting Socat ...'
   socat tcp-l:$HEALTH_PORT,reuseaddr,fork EXEC:"/usr/scripts/bashttpd" &
  fi

  log 'Sleeping for 1m'
  sleep 60
done
