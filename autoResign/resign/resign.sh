#!/bin/sh


if [ $# -lt 1 ]; then
    echo ""
    echo "resign.sh Usage:"
    echo "\t required: ./resign.sh APP_NAME.ipa true"
    exit 0
fi

source resign.config

echo "read config.plist"

TARGET_IPA_PACKAGE_NAME=$1                                                         # 需要被重签的ipa名字
TM_IPA_PACKAGE_NAME="${TARGET_IPA_PACKAGE_NAME%.*}_TM.ipa"                         # 重签名以后的ipa名字
PAYLOAD_DIR="Payload"
APP_DIR=""
PROVISION_FILE=$NEW_MOBILEPROVISION
CODESIGN_KEY=$CODESIGN_IDENTITIES
ENTITLEMENTS_FILE=$ENTITLEMENTS
echo -e "$2"
if [[ $2 == 'true' ]]; then
  echo "resign with development type"
    PROVISION_FILE=$NEW_MOBILEPROVISION_DEV
    CODESIGN_KEY=$CODESIGN_IDENTITIES_DEV
    ENTITLEMENTS_FILE=$ENTITLEMENTS_DEV
fi

OLD_MOBILEPROVISION="embedded.mobileprovision" # 配置文件
DEVELOPER=`xcode-select -print-path`
TARGET_APP_FRAMEWORKS_PATH=""

SDK_DIR="${DEVELOPER}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
echo -e "SDK_DIR*$SDK_DIR"

if [ ! -e $TARGET_IPA_PACKAGE_NAME ]; then
    echo "ipa file ($TARGET_IPA_PACKAGE_NAME) not exist"
    exit 0
fi

if [ ! -e $PROVISION_FILE ]; then
    echo "provision file ($PROVISION_FILE) not exist"
    exit 0
fi

if [ -e $TM_IPA_PACKAGE_NAME ]; then
    echo "rm $TM_IPA_PACKAGE_NAME"
    rm $TM_IPA_PACKAGE_NAME
fi

if [ -d $PAYLOAD_DIR ]; then
    rm -rf $PAYLOAD_DIR
fi

echo ""
echo "1. unzip $TARGET_IPA_PACKAGE_NAME"
unzip $TARGET_IPA_PACKAGE_NAME > /dev/null

if [ ! -d $PAYLOAD_DIR ]; then
    echo "unzip $TARGET_IPA_PACKAGE_NAME fail"
fi

for DIR in `ls $PAYLOAD_DIR/`
do
    if [ -d $PAYLOAD_DIR/$DIR ]; then
        APP_DIR=$PAYLOAD_DIR/$DIR
        echo "APP DIR : $APP_DIR"
        break
    fi
done

if [ -d $APP_DIR/_CodeSignature ]; then
    echo ""
    echo "2. rm $APP_DIR/_CodeSignature"
    rm -rf $APP_DIR/_CodeSignature

    echo ""
    echo "4. cp $SDK_DIR/ResourceRules.plist $APP_DIR/"
    cp $SDK_DIR/ResourceRules.plist $APP_DIR/
    echo ""
    echo "5. cp $PROVISION_FILE $APP_DIR/$OLD_MOBILEPROVISION"
    cp $PROVISION_FILE $APP_DIR/$OLD_MOBILEPROVISION
    echo ""
    echo "6. codesign....."
#codesign frameworks
TARGET_APP_FRAMEWORKS_PATH="$APP_DIR/Frameworks"
if [[ -d "$TARGET_APP_FRAMEWORKS_PATH" ]]; then
    for FRAMEWORK in "$TARGET_APP_FRAMEWORKS_PATH/"*; do
        FILENAME=$(basename $FRAMEWORK)
        /usr/bin/codesign -f -s "$CODESIGN_KEY" "$FRAMEWORK"
    done
fi
#codesign plugins
TARGET_APP_PLUGINS_PATH="$APP_DIR/PlugIns"
if [[ -d "$TARGET_APP_PLUGINS_PATH" ]]; then
    for PLUGIN in "$TARGET_APP_PLUGINS_PATH/"*; do
        echo "PLUGIN($PLUGIN)"
        FILENAME=$(basename $PLUGIN)
        echo "FILENAME($FILENAME)"
        /usr/bin/codesign -f -s "$CODESIGN_KEY" "$PLUGIN"
    done
fi

    /usr/bin/codesign -f -s "$CODESIGN_KEY" --entitlements $ENTITLEMENTS_FILE  $APP_DIR
    if [ -d $APP_DIR/_CodeSignature ]; then
        echo ""
        echo "7. zip -r $TARGET_IPA_PACKAGE_NAME $APP_DIR/"
        zip -r $TM_IPA_PACKAGE_NAME $APP_DIR/ > /dev/null
        rm -rf $APP_DIR
        echo " @@@@@@@ resign success !!!  @@@@@@@ "
        exit 0
    fi
fi

echo "resign fail !!"
