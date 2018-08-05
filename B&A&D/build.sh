#!/bin/bash
# https://developer.apple.com/library/content/technotes/tn2215/_index.html
# https://itunesconnect.apple.com/docs/UsingApplicationLoader.pdf
# http://www.matrixprojects.net/p/xcodebuild-export-options-plist/
# http://www.voidcn.com/blog/potato512/article/p-6165228.html
# http://www.jianshu.com/p/bd4c22952e01
# ``有返回值
# ''不做格式化
# ""做格式化
# 0标准输入（stdin）,1标准输出(stdout), 2标准错误(stderr)
# error: exportArchive: No applicable devices found. solution: https://github.com/bitrise-io/steps-xcode-archive/issues/37  rvm use system
# xcodebuild exit code :https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/sysexits.3.html#//apple_ref/doc/man/3/sysexits

ALTOOL_DIR="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
ARCHIVE_SCHEME_NAME="wsyun"
ARCHIVE_PROJECT_NAME="wsyun.xcodeproj"
ApplicationLoader_UserName="xxx@yyy.com" # you account which used in itnueconnect
ApplicationLoader_Password="iTunes Producer: xxx@yyy.com" # you password which used in itnueconnect and can find in you keychain


BUGTRACKER_URL="svn://xxxxxx/BugTracker" # 
BUGTRACKER_DIR="$HOME/Documents"
BUGTRACKER="BugTracker"
IPA_PREFIX_APPSTORE="${ARCHIVE_SCHEME_NAME}_AppStore_"
IPA_PREFIX_ENTERPRISE="${ARCHIVE_SCHEME_NAME}_ENT_"
CUR_PATH="$PWD"
PROJECT_DIR="${CUR_PATH}"

BUILD_TIME=`date "+%m-%d-%y, %l.%M %p"`
BUILD_DATE=`date "+%Y-%m-%d"`
EXPORT_TIME=`date "+%Y%m%d%H_%M"`
APP_VERSION="agvtool what-marketing-version -terse1"

ARCHIVE_FILE_NAME="$ARCHIVE_SCHEME_NAME $BUILD_TIME.xcarchive"
ARCHIVE_FILE_PATH="$HOME/Library/Developer/Xcode/Archives/${BUILD_DATE}/${ARCHIVE_FILE_NAME}"
ARCHIVE_LOG_FILE_NAME="archive.log"
# ARCHIVE_FILE_PATH="$HOME/Library/Developer/Xcode/Archives/2017-06-06/UOne 06-06-17,  3.56 PM.xcarchive"


OUTPUT_IPA_APPSTORE="$HOME/Desktop/ipa/${ARCHIVE_SCHEME_NAME}_AppStore/$ARCHIVE_SCHEME_NAME"
OUTPUT_IPA_ENTERPRISE="$HOME/Desktop/ipa/${ARCHIVE_SCHEME_NAME}_EnterPrise/$ARCHIVE_SCHEME_NAME"

APPSTORE_RESPONED_FILE_NAME="respon.plist"

function set_publish_mode() {
echo "set UOneConfig.plist to publish mode ${PROJECT_DIR}"
cd "${PROJECT_DIR}/WSPXBrowser"
plutil -p UOneConfig.plist
plutil -replace PMSServiceType -integer 0 UOneConfig.plist
plutil -replace UOneServiceType -integer 0 UOneConfig.plist
plutil -replace CrashMonitor -bool true UOneConfig.plist
plutil -replace NSLogToFile -bool false UOneConfig.plist
plutil -p UOneConfig.plist
sed -i.bak 's/kWspxTest                       (1)/kWspxTest                       (0)/g' WSPXUOneDefine.h
sed -i.bak 's/wspxUILog                       (1)/wspxUILog                       (0)/g' WSPXUOneDefine.h
sed -i.bak 's/kWspxCustomPhoneTest            (1)/kWspxCustomPhoneTest            (0)/g' WSPXUOneDefine.h
sed -i.bak 's/kSwitchToLocalJsFile            (1)/kSwitchToLocalJsFile            (0)/g' WSPXUOneDefine.h

rm WSPXUOneDefine.h.bak
echo 'set WSPXUOneDefine.h to RELEASE DONE'
}

function build_enterprise() {
echo -e "构建企业版${ARCHIVE_SCHEME_NAME} build at: ${BUILD_TIME}"
echo -e ""
set_publish_mode
cd $PROJECT_DIR
echo "arguments $* "

agvtool what-marketing-version # update CFBundleShortVersionString
agvtool new-marketing-version $1

agvtool what-version # update CFBundleVersion
agvtool new-version -all $[ $2+1 ]
echo 'clear...'
xcodebuild clean -project "$ARCHIVE_PROJECT_NAME" -configuration Release -quiet
echo -e "xcodebuild clean exit code:$?"

echo 'archive...'
if [[ -e "${ARCHIVE_LOG_FILE_NAME}" ]]; then
rm $ARCHIVE_LOG_FILE_NAME
fi
xcodebuild archive -project ./"$ARCHIVE_PROJECT_NAME" -scheme "$ARCHIVE_SCHEME_NAME" -configuration Release -archivePath "$ARCHIVE_FILE_PATH" CODE_SIGN_IDENTITY="iPhone Developer" -quiet > $ARCHIVE_LOG_FILE_NAME #PROVISIONING_PROFILE="Automatic" #-quiet > /dev/null #貌似不指定provisioning_profile才是真的automatic
checkXcodebuildExitCode
rm -r "build"
echo 'exportArchive...'
xcodebuild -exportArchive -archivePath "$ARCHIVE_FILE_PATH" -exportPath "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`" -exportOptionsPlist ./exportOptions/$3.plist 

echo -e "move ipa file to :$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/"
if [[ ! -e "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`" ]]; then
echo -e "create ipa directory.:$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`"
mkdir $OUTPUT_IPA_ENTERPRISE`$APP_VERSION`

fi

mv -i "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/$ARCHIVE_SCHEME_NAME.ipa" "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/${IPA_PREFIX_ENTERPRISE}${EXPORT_TIME}.ipa"
if [[ -e  "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/${IPA_PREFIX_ENTERPRISE}${EXPORT_TIME}.ipa" ]]; then
echo "open directory===>$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/"
open "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/"
fi
}

function build_appStore() {
echo -e "构建商店版${ARCHIVE_SCHEME_NAME}  build at: ${BUILD_TIME}"
echo -e ""
set_publish_mode
cd "$PROJECT_DIR/AppStore"
echo "arguments $*"

agvtool what-marketing-version
agvtool new-marketing-version $1

agvtool what-version
agvtool new-version -all $[ $2+2 ]
echo 'clear...'
xcodebuild clean -project "$ARCHIVE_PROJECT_NAME" -configuration Release -quiet
echo -e "xcodebuild clean exit code:$?"

echo 'archive...'
if [[ -e "${ARCHIVE_LOG_FILE_NAME}" ]]; then
rm $ARCHIVE_LOG_FILE_NAME
fi
xcodebuild archive -project ./"$ARCHIVE_PROJECT_NAME" -scheme "$ARCHIVE_SCHEME_NAME" -configuration Release -archivePath "$ARCHIVE_FILE_PATH" CODE_SIGN_IDENTITY="iPhone Developer" -quiet > $ARCHIVE_LOG_FILE_NAME   #PROVISIONING_PROFILE="Automatic" -quiet > /dev/null #貌似不指定provisioning_profile才是真的automatic

checkXcodebuildExitCode

rm -r "build"
echo 'exportArchive...'
xcodebuild -exportArchive -archivePath "$ARCHIVE_FILE_PATH" -exportPath "$OUTPUT_IPA_APPSTORE`$APP_VERSION`" -exportOptionsPlist ../exportOptions/$3.plist

echo -e "move ipa file to :$OUTPUT_IPA_APPSTORE`$APP_VERSION`/"
if [[ ! -e "$OUTPUT_IPA_APPSTORE`$APP_VERSION`" ]]; then
echo -e "create ipa directory.:$OUTPUT_IPA_APPSTORE`$APP_VERSION`"
mkdir $OUTPUT_IPA_APPSTORE`$APP_VERSION`

fi

mv -i "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/$ARCHIVE_SCHEME_NAME.ipa" "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/${IPA_PREFIX_APPSTORE}${EXPORT_TIME}.ipa"
if [[ -e  "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/${IPA_PREFIX_APPSTORE}${EXPORT_TIME}.ipa" ]]; then
echo "open directory===>$OUTPUT_IPA_APPSTORE`$APP_VERSION`/"
open "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/"
fi
}

function deliver_appStore() {
echo -e "Uploading Your Application Binary Files with altool..."
"$ALTOOL_DIR" --upload-app -f "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/${IPA_PREFIX_APPSTORE}${EXPORT_TIME}.ipa" -u "$ApplicationLoader_UserName" -p @keychain:"$ApplicationLoader_Password" --output-format xml > $APPSTORE_RESPONED_FILE_NAME
}

function echoSVNStatus() {
echo -e ""
echo -e "Time:`date "+%m-%d-%y, %l.%M.%S %p"`"
echo -e "SVN STATUS:"
svn status
}

function bugTracker() {
echo -e "checkout BugTracker..."
svn checkout ${BUGTRACKER_URL} ${BUGTRACKER_DIR}/${BUGTRACKER} 1> /dev/null

if [[ ! -e "${BUGTRACKER_DIR}/${BUGTRACKER}" ]]; then
echo -e "create BugTracker directory."
mkdir ${BUGTRACKER_DIR}/$BUGTRACKER
svn mkdir -m "create BugTracker directory." ${BUGTRACKER_URL}
svn checkout ${BUGTRACKER_URL} ${BUGTRACKER_DIR}/${BUGTRACKER} 1> /dev/null
fi

dSYMsFile=`ls "${ARCHIVE_FILE_PATH}"/dSYMs/`
BaseString=`xcrun dwarfdump --uuid "${ARCHIVE_FILE_PATH}/dSYMs/${dSYMsFile}" | sed -n -e '/UUID:/p' | grep "UUID:.*" | awk '{split( $0, a, " "); print a[2]}' `
commitMessage=`echo $BaseString | sed 's/ /;/g'`
UUIDFile=`echo $BaseString | sed 's/-//g' | sed 's/ //g' `
echo -e "UUIDFILE:${UUIDFile}"

filePath=${BUGTRACKER_DIR}/${BUGTRACKER}/${ARCHIVE_SCHEME_NAME}/`$APP_VERSION`/${UUIDFile}
mkdir -p $filePath

echo -e "copy dSYMsFile:${dSYMsFile} to BugTracker..."
cp -R "${ARCHIVE_FILE_PATH}/dSYMs/${dSYMsFile}" "${filePath}/${UUIDFile}.dSYM"
if [[ $? -gt 0 ]]; then
echo "cp dSYMsFile:${dSYMsFile} failed"
fi

if [[ $1 == 'enterprise' ]]; then
echo -e "copy enterprise ipa to BugTracker..."
cp -R "$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/${IPA_PREFIX_ENTERPRISE}${EXPORT_TIME}.ipa" "${filePath}"
if [[ $? -gt 0 ]]; then
echo -e "copy ipa failed:$OUTPUT_IPA_ENTERPRISE`$APP_VERSION`/${IPA_PREFIX_ENTERPRISE}${EXPORT_TIME}.ipa"
fi
else
echo -e "copy app-store ipa to BugTracker..."
cp -R "$OUTPUT_IPA_APPSTORE`$APP_VERSION`/${IPA_PREFIX_APPSTORE}${EXPORT_TIME}.ipa" "${filePath}"
if [[ $? -gt 0 ]]; then
echo -e "copy ipa failed:$OUTPUT_IPA_APPSTORE`$APP_VERSION`/${IPA_PREFIX_APPSTORE}${EXPORT_TIME}.ipa"
fi
fi

cd $BUGTRACKER_DIR/$BUGTRACKER
echoSVNStatus

echo -e "SVN ADD"
svn add ${ARCHIVE_SCHEME_NAME} --force

echo "SVN COMMIT"
svn commit -m "version:${APP_VERSION} $1=>${commitMessage}"

echoSVNStatus
}

SUCCESS_MESSAGE="success-message"
PRODUCT_ERRORS="product-errors"

function checkResponse() {

if [[ ! -e $APPSTORE_RESPONED_FILE_NAME ]]; then
echo -e ""
echo -e "file -->$APPSTORE_RESPONED_FILE_NAME not exist!!!"
exit 1
fi

echo -e "---------------------------->check response<----------------------------"

RETURN=`plutil -p $1 | grep "$SUCCESS_MESSAGE"`
if [[ $RETURN == *"$SUCCESS_MESSAGE"* ]]; then
STATUS=`plutil -p $1 | sed -n -e "/$SUCCESS_MESSAGE/,/dev-tools/p"`
echo -e "response message:"
echo -e "$STATUS"
rm $1
return 0
fi

RETURN=`plutil -p $1 | grep "$PRODUCT_ERRORS"`
if [[ $RETURN == *"$PRODUCT_ERRORS"* ]]; then
STATUS=`plutil -p $1 | sed -n -e "/$PRODUCT_ERRORS/,/]/p"`
echo -e "response message:"
echo -e "$STATUS"
return 1
fi

return 1
}

function checkXcodebuildExitCode() {
XcodebuildExitCode=$?
echo -e "xcodebuild archive exit code:${XcodebuildExitCode}"

if [[ $XcodebuildExitCode == 0 ]]; then
echo -e "xcodebuild archive succed!"
rm $ARCHIVE_LOG_FILE_NAME
else
echo -e "xocodebuild archive failed, please see ${ARCHIVE_LOG_FILE_NAME}"
echo -e "open ${ARCHIVE_LOG_FILE_NAME}"
open $ARCHIVE_LOG_FILE_NAME
exit 1
fi
}

function usage() {
echo -e ""
echo -e "build.sh command"
echo -e "command:"
echo -e " ./build.sh reset                  reset UOneConfig.plist,WSPXUOneDefine.h to the publish mode."
echo -e " ./build.sh archive.config         reset UOneConfig.plist,WSPXUOneDefine.h and archive project then output ipa."
echo -e ""
}

function faq() {
echo -e "系统要求:Xcode 8.1 "
echo -e "使用该脚本之前请确保已经在本机安装了对应的证书和描述文件."
echo -e "error: exportArchive: No applicable devices found. solution: https://github.com/bitrise-io/steps-xcode-archive/issues/37  rvm use system"

}

if [ $# != 1 ] ; then
usage
exit 0
fi

faq

if [[ $1 == 'reset' ]]; then
set_publish_mode
elif [[ $1 == *"config"* ]]; then
source ./$1
if [[ $TYPE == 'enterprise' ]]; then
build_enterprise $VERSION $EP_BUILDVERSION enterprise
if [[ $RELEASE == 'true' ]]; then
bugTracker $TYPE
fi
elif [[ $TYPE == 'appstore' ]]; then
build_appStore $VERSION $AS_BUILDVERSION app-store
if [[ $DELIVER_TO_APPSTORE == 'true' ]]; then
deliver_appStore
checkResponse $APPSTORE_RESPONED_FILE_NAME
result=$?
echo -e "---------------------------- checkResponse return value:$result ----------------------------"
if [[ $result == 0 ]]; then
bugTracker $TYPE
fi
fi

elif [[ $TYPE == 'ad-hoc' ]]; then
build_appStore $VERSION $BUILDVERSION ad-hoc
fi
else
usage
fi

