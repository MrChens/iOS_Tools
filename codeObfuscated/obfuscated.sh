#!/usr/bin/env bash

TABLENAME=symbols
SYMBOL_DB_FILE="symbols"
STRING_SYMBOL_FILE="obfuscation.list"
TIME=`date "+%Y%m%d%H_%M"`
HEAD_FILE="$PROJECT_DIR/codeObfuscation.h"
export LC_CTYPE=C

#维护数据库方便日后作排重
createTable() {
    echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue() {
    echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query() {
    echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

isUnique() {
    echo "select count(*) from $TABLENAME where des='$1';" | sqlite3 $SYMBOL_DB_FILE
}

randomString() {
    random=`openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16`
    count=`isUnique $random`
    if [[ $count == 0 ]]; then
        echo $random
    else
        randomString
    fi
}

codeObfuscation() {
    if [[ ! -e  "$SYMBOL_DB_FILE" ]]; then
        echo "***create table***"
        createTable
    fi

    if [[ ! -e "${HEAD_FILE}" ]]; then
        echo "***touch $HEAD_FILE***"
        touch $HEAD_FILE
        echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
        echo "//confuse string at `date`" >> $HEAD_FILE
    else
        echo $TIME
        sed -i.$TIME.bak '/#endif/d' $HEAD_FILE
    fi

    cat "$STRING_SYMBOL_FILE" | while read -ra line; do
        if grep -q " $line " "$HEAD_FILE"; then
            echo "already exist $line"
        else
            if [[ ! -z "$line" ]]; then
            ramdom=`randomString`
            echo "***define $line $ramdom***"
            insertValue $line $ramdom
            echo "#define $line $ramdom" >> $HEAD_FILE
        fi
        fi
    done

    echo "#endif" >> $HEAD_FILE

    echo "***sqlite dump $SYMBOL_DB_FILE***"
    sqlite3 $SYMBOL_DB_FILE .dump
}

codeObfuscation
# randomString
