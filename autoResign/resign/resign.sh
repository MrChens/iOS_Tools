#!/bin/sh


if [ $# -lt 2 ]; then
    echo ""
    echo "resign.sh Usage:"
    echo "\t required: ./resign.sh APP_NAME.ipa APP_NAME.mobileprovision"
    exit 0
fi
# echo -e "panda:$PWD"
source resign.config

CP_IPA_PACKAGE_NAME=$1                                                         # 需要被重签的ipa名字
TM_IPA_PACKAGE_NAME="${CP_IPA_PACKAGE_NAME%.*}_TM.ipa"                         # 重签名以后的ipa名字
PROVISION_FILE=$2
PAYLOAD_DIR="Payload"
APP_DIR=
CODESIGN_KEY=$CODESIGN_IDENTITIES
ENTITLEMENTS_FILE=$ENTITLEMENTS
OLD_MOBILEPROVISION="embedded.mobileprovision" # 配置文件
DEVELOPER=`xcode-select -print-path`

SDK_DIR="${DEVELOPER}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
echo -e "SDK_DIR*$SDK_DIR"
exit 1
if [ ! -e $CP_IPA_PACKAGE_NAME ]; then
    echo "ipa file ($CP_IPA_PACKAGE_NAME) not exist"
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
echo "1. unzip $CP_IPA_PACKAGE_NAME"
unzip $CP_IPA_PACKAGE_NAME > /dev/null

if [ ! -d $PAYLOAD_DIR ]; then
    echo "unzip $CP_IPA_PACKAGE_NAME fail"
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
    /usr/bin/codesign -f -s "$CODESIGN_KEY" --entitlements $ENTITLEMENTS_FILE  $APP_DIR
    if [ -d $APP_DIR/_CodeSignature ]; then
        echo ""
        echo "7. zip -r $CP_IPA_PACKAGE_NAME $APP_DIR/"
        zip -r $TM_IPA_PACKAGE_NAME $APP_DIR/ > /dev/null
        rm -rf $APP_DIR
        echo " @@@@@@@ resign success !!!  @@@@@@@ "
        exit 0
    fi
fi

echo "resign fail !!"
