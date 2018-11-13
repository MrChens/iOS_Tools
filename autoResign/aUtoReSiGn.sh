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

WHICH_BREW=`which brew`
WHICH_FSWATCH=`which fswatch`
WHICH_IDEVICEINSTALLER=`which ideviceinstaller`

SCAN_TITME=1 #扫描文件变化的间隔  1/秒
function checkFswatch() {
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

function checkPathExist() {
    if [[ ! -e $INPUT_PATH ]]; then
        echo "MKDIR ${INPUT_PATH}"
        mkdir $INPUT_PATH
    fi

    if [[ ! -e $OUTPUT_PATH ]]; then
        echo "MKDIR ${OUTPUT_PATH}"
        mkdir $OUTPUT_PATH
    fi
}

function checkIdeviceinstaller() {
    if [[ ${WHICH_IDEVICEINSTALLER} == *"ideviceinstaller"* ]]; then
        echo "ideviceinstaller is installed."
    else
        if [[ ${WHICH_BREW} == *"brew"* ]]; then
            echo "brew has installed."
            echo "auto install ideviceinstaller, please wait I'm working on:"
            brew install ideviceinstaller
            # brew uninstall ideviceinstaller
            # brew uninstall libimobiledevice
            # brew install --HEAD libimobiledevice
            # brew link --overwrite libimobiledevice
            # brew install ideviceinstaller
            # brew link --overwrite ideviceinstaller
            # or
            # brew update
            # brew uninstall --ignore-dependencies libimobiledevice
            # brew uninstall --ignore-dependencies usbmuxd
            # brew install --HEAD usbmuxd
            # brew unlink usbmuxd
            # brew link usbmuxd
            # brew install --HEAD libimobiledevice
        fi
    fi
}

function doInstall() {
    echo "call doInstall with:$1"
    if [[ -f "${OUTPUT_PATH}/${1}" ]]; then
                            echo "READY TO INSTALL ${1} TO IPHONE"
                            ideviceinstaller -g "${OUTPUT_PATH}/${1}"
                        else
                            echo "${1} NOT EXIST"
                        fi
}

function doResignWork() {
    echo "call doResignWork with:$1"
    if [[ -f "${INPUT_PATH}/${1}" ]]; then
                            echo "READY TO RESIGN ${1}"
                            APP_NAME=${1}
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
                                echo "${1} NOT EXIST"
                        fi

}

function monitor_ipa() {
    fswatch -l $SCAN_TITME -v --monitor=fsevents_monitor -0 "${INPUT_PATH}/" "${OUTPUT_PATH}/" | while read -d "" event
    do
        echo "FINE HAS CHANGED EVENT:${event}"
        if [[ ${event} == *"${INPUT_DIR}"* && ${event} == *"ipa" && ${event} != *"TM.ipa" ]]; then
            echo "HANDLE INPUT_DIR EVENT:"
            IFS='/' read -ra array <<< ${event}
                for i in ${array[@]}; do
                    if [[ ${i} == *"ipa" ]]; then
                        doResignWork "${i}"
                    fi
                done
        elif [[ ${event} == *"${OUTPUT_DIR}"*  ]]; then
            echo "HANDLE OUTPUT_DIR EVNET:"
            IFS='/' read -ra array <<< ${event}
                for i in ${array[@]}; do
                    if [[ ${i} == *"TM.ipa" ]]; then
                        doInstall "${i}"
                    fi
                done
        fi
    done
}


checkPathExist
checkFswatch
checkIdeviceinstaller
monitor_ipa
