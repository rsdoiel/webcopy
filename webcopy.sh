#!/bin/bash
#
# Spider and copy a website using wget into a local directory.
#

usage () {
    echo 'USAGE: webcopy.sh TARGET_URL'
    echo ''
    echo 'Example:'
    echo './webcopy.sh http://example.com'
    echo ''
    exit 1
}

runSpider() {
    # Calculate the hostname directory.
    H=${1/*:\/\/}
    H=${H/\/*}
    echo 'Web copy will log to webcopy.log'
    echo 'Use:'
    echo '    tail -f webcopy.log'
    echo 'to monitor process'
    echo ''
    wget --mirror \
        --force-directories \
        --timestamping \
        --page-requisites \
        --no-cache \
        --base=$1 \
        --referer=$1 \
        --domain $H \
        --output-file=webcopy.log \
        -H $1
    
    # Back up our mirrored copy to make debugging easier.
    zip -r $H-original.zip $H webcopy.log
}

relinkSavedFiles() {
    H=${1/*:\/\/}
    H=${H/\/*}
    URL=${1//\//\\\/}
    URL_REPLACE_EXP="s/$URL//g"
                
    echo "Relinking saved files." 
    find $H -type f | grep -viE '\.(pdf|jpg|gif|png|mov|avi|woff|eot|ttf|svg)' | while read ITEM; do
        # Convert google cache braking parameters and post ids.
        TARGET=$(grep -E "\w+\?\w+=" "$ITEM")
        if [ "$TARGET" != "" ]; then
             echo -n "."
# Manual process I do the following for .js and .css files references.
# sed -i .bak -E -e "s/\.css\?\w+=\w+/.css/g" -e "s/\.js\?\w+=\w+/.js/g" "$ITEM" to update file.
# Still need to rewrite index.html?p=#### to post-####.html and adjust links
# sed -E -e "s/index\.html\?p=[0-9]+/page-&.html/g" -e "s/index.html\?p=//g"
             #echo "Updating $ITEM"
             sed -i .bak -E -e "s/\.css\?v=[0-9]+/.css/g" \
                            -e "s/\.js\?v=[0-9]+/.js/g" \
                            -e "s/index\.html\?p=[0-9]+/page-&.html/g" \
                            -e "s/index.html\?p=//g" \
                            -e $URL_REPLACE_EXP \
                            -e "s/..\/ajax.googleapis.com/ajax.googleapis.com/g" \
                            "$ITEM"
             #if [ -f "$ITEM.bak" ]; then
                # /bin/rm "$ITEM.bak"
             #fi
        else
             echo -n "_"
        fi
    done
}

renameSavedFiles() {
    H=${1/*:\/\/}
    H=${H/\/*}
    if [ -d ajax.googleapis.com ]; then
        cp -vR ajax.googleapis.com $H/
    fi
    find $H -type f | grep -E '\.(js|css)\?\w+=\w+' | while read ITEM; do
        NEW_NAME=${ITEM/\?*/}
        echo "Renaming $ITEM to $NEW_NAME"
        mv "$ITEM" "$NEW_NAME"
    done
    find $H -type f | grep -E '\.html\?p=\w+' | while read ITEM; do
        ID=$(echo "$ITEM" | cut -d = -f 2)
        NEW_PATH=$(echo "$ITEM" | sed -E -e "s/index\.html\?p=[0-9]+//g")
        NEW_NAME="page-$ID.html"
        echo "Renaming $ITEM to $NEW_PATH$NEW_NAME"
        mv "$ITEM" "$NEW_PATH$NEW_NAME"
    done
}

if [ "$1" = "" ]; then
    usage
fi

runSpider $1 
renameSavedFiles $1
relinkSavedFiles $1
