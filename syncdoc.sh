#!/bin/bash

DELETE=""
DRYRUN=""

while [[ $# > 0 ]]; do
    key="$1"
    case $key in
        -d|--delete) DELETE="--delete" ;;
        -n|--dry-run) DRYRUN="--dry-run" ;;
        *);;
    esac
    shift
done

rsync $DELETE $DRYRUN -av --exclude 'Documents/R' /cygdrive/e/Yinghua/Documents  /cygdrive/f/GDrive/Home/
rsync $DELETE $DRYRUN -av /cygdrive/e/Yinghua/Pictures   /cygdrive/f/GDrive/Home/

