#! /bin/sh

SCRIPTNAME=$(basename "$0")
NAME=cloud-native-app-demo

case "$1" in
  start)
    k3d cluster create $NAME -c k3d.yaml
    ;;
  stop)
    k3d cluster rm $NAME
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop}" >&2
    exit 1
    ;;
esac
