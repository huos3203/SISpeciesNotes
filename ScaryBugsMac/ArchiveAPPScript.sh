#!/bin/sh

#  ArchiveAPPScript.sh
#  ScaryBugsMac
#
#  Created by pengyucheng on 16/8/8.
#  Copyright © 2016年 recomend. All rights reserved.
CONFIG_ROOT_PATH="/Users/jc/Desktop/yourproject/"
cd $CONFIG_ROOT_PATH
#循环数组 channelid
CHANNELID=("aaa" "bbb" "ccc")
CHANNEL_SECRET=("111" "222" "333")
secret
for ((i=0;i<${$CHANNELID[@]};i++))
do
#删除
rm -rf "/Users/jc/Desktop/yourproject/build/"
#清除
xcodebuild -target PBB clean
echo ${CHANNELID[$i]}
echo ${CHANNEL_SECRET[$i]}
#修改plist
/usr/libexec/PlistBuddy -c "set :CHANNELID ${CHANNELID[$i]}" /Users/jc/Desktop/yourproject/woMusic/AppConfig.plist
/usr/libexec/PlistBuddy -c "set :CHANNEL_SECRET ${CHANNEL_SECRET[$i]}" /Users/jc/Desktop/yourproject/woMusic/AppConfig.plist
#打包
xcodebuild -target woMusic -configuration Distribution -sdk iphoneos build
#生成ipa
xcrun -sdk iphoneos PackageApplication -v "/Users/jc/Desktop/yourproject/build/Release-iphoneos/yourapp.app" -o "/Users/jc/Desktop/yourproject/yourappname_${CHANNELID[$i]}.ipa"
done

#递增build版本号，重命名app带版本号的文件名称
PLIST_FILE_PATH = 'Recommend/Info.plist'
buildVersion = 1
ImportSVN = "importSVN"
def set_info_plist_value(path,key,value)
sh "/usr/libexec/PlistBuddy -c \"set :#{key} #{value}\" #{path}"
end


def set_buildVersion_id(buildVersion)
set_info_plist_value(
"./../#{PLIST_FILE_PATH}",
'CFBundleVersion',
"#{buildVersion}"
)
end

set_buildVersion_id(buildVersion)

cur_dir="$TARGET_BUILD_DIR/"
cd ${cur_dir}
#新建导入目录
mkdir "${ImportSVN}_${buildVersion}"
cp -f "$PRODUCT_NAME.app" "${ImportSVN}/$PRODUCT_NAME_${buildVersion}.app"
svn import "${ImportSVN}" https:\/\/192.168.85.64/svn/安装包/MAC -m "${buildVersion}"




