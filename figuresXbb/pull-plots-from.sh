#!/usr/bin/env bash

set -eu

SUBDIR=pulled

if (($# != 1)); then
    echo 'Give a plots directory to pull from' >&2
    cat <<EOF

This will look for updated versions of the plots in $SUBDIR and update
them if they are found.

EOF
    exit 1
fi

SOURCE=$1
DEST=${BASH_SOURCE[0]%/*}/${SUBDIR}

cd $DEST
find . -type f | while read TARGET; do
    SRC_FILE=${SOURCE%/}/${TARGET#./}
    if ! [[ -f $SRC_FILE ]]; then
        echo "Source file for ${TARGET} not found, skipping" >&2
    elif [[ $SRC_FILE -nt $TARGET ]]; then
        echo "Updating ${TARGET}"
        cp -f $SRC_FILE $TARGET
    else
        echo "Existing ${TARGET} is as new as source, skipping"
    fi
done

