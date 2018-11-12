#!/bin/sh
OUTPUT_DIR="output"
INPUT_DIR="input"
RESIGN_DIR="resign"
MYPATH=$(dirname "$0")
INPUT_PATH="${MYPATH}/${INPUT_DIR}"
OUTPUT_PATH="${MYPATH}/${OUTPUT_DIR}"
RESIGN_PATH="${MYPATH}/${RESIGN_DIR}"
source ./resign/resign.config
PROVISIONING_PROFILE=$NEW_MOBILEPROVISION
CURRENT_TIME_FORMAT="+%m-%d-%y, %l.%M.%S %p"

SCAN_TITME=1 #扫描文件变化的间隔  1/秒
function checkSystem() {
    WHICH_BREW=`which brew`
    WHICH_FSWATCH=`which fswatch`
echo -e "MYPATH:$MYPATH"
echo -e "INPUT_PATH:$INPUT_PATH"
# exit 1

    if [[ ${WHICH_FSWATCH} == *"fswatch"* ]]; then
        echo "fswatch installed"
    else
        if [[ ${WHICH_BREW} == *"brew"* ]]; then
            echo "brew installed"
            echo "auto install fswatch, please wait I'm working on:"
            brew install fswatch
        else
            echo "auto install brew:"
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
    fi
}

function monitor_ipa_in_output() {
    fswatch -l $SCAN_TITME -v --monitor=fsevents_monitor -0 "${OUTPUT_PATH}/" | while read -d "" event
    do
        # echo "event:${event}"
        echo "File has changed in ${OUTPUT_PATH}"
        if [[ ${event} == *"ipa" ]]; then
            IFS='/' read -ra array <<< ${event}
                for i in ${array[@]}; do
                    if [[ ${i} == *"ipa" ]]; then
                        if [[ -e "${OUTPUT_PATH}/${i}" ]]; then
                            echo "READY TO install ipa:${i} to iPhone"
                            ideviceinstaller -g "${OUTPUT_PATH}/${i}"
                        fi
                    fi
                done
        fi
    done
}

function monitor_ipa() {
    fswatch -l $SCAN_TITME -v --monitor=fsevents_monitor -0 "${INPUT_PATH}/" | while read -d "" event
    do
        echo "file has changed in ${INPUT_PATH}"
        if [[ ${event} == *"ipa" && ${event} != *"TM.ipa" ]]; then
            IFS='/' read -ra array <<< ${event}
                for i in ${array[@]}; do
                    if [[ ${i} == *"ipa" ]]; then
                        echo "current file:${i}"
                        if [[ -e "${INPUT_PATH}/${i}" ]]; then
                            echo "READY TO RESIGN PACKAGE:${i}"
                            APP_NAME=${i}
                            # echo "@1CurrentPath:$PWD"
                            cp "$INPUT_PATH/${APP_NAME}" "${RESIGN_PATH}/"
                            # echo "@2CurrentPath:$PWD"
                            cd "${RESIGN_PATH}/"
                            # echo "@3CurrentPath:$PWD"
                            "./resign.sh" $APP_NAME $GET_TASK_ALLOW
                            cd "-"
                            # echo "@4CurrentPath:$PWD"
                            rm -rf "${RESIGN_PATH}/${APP_NAME}"
                            FINAL_FILE=`ls ${RESIGN_PATH} | grep "ipa"`
                            if [[ -f  "${RESIGN_PATH}/${FINAL_FILE}" ]]; then
                                mv "${RESIGN_PATH}/${FINAL_FILE}" "${OUTPUT_PATH}"
                            else
                                echo "failed: file not exist"
                            fi
                            echo "TIME:`date "${CURRENT_TIME_FORMAT}"`"
                        else
                                echo "NOT EXIST PACKAGE:${i}"
                        fi
                    fi
                done
        fi
    done
}

checkSystem
monitor_ipa
monitor_ipa_in_output
