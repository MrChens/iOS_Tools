推送证书的生成：
================

1.	在identifiers-->App IDs中找到对应的appid
2.	点击edit-->Create Certificate...
3.	制作CSR文件:打开钥匙串-->证书助理-->从证书颁发机构请求证书(填写账号的邮箱和存储到磁盘)
4.	返回到刚才的Create Certificate中点击Choose File选择刚才生成的CSR文件然后点击Continue
5.	下载证书并双击打开钥匙串访问，在左边的证书中选择刚刚弄的好的证书，右键导出为p12文件
6.	然后使用apnsPem.sh来创建pem文件。(提示输入密码，输入刚才导出p12时的密码)

Generate apns pem file
======================

1.	Login you apple Developer account in https://developer.apple.com/
2.	In `Identifiers` click `App IDs` then Choose you `iOS App IDs` which you wanna create apns pem file.
3.	Expanding it and click `edit`
4.	Before you click `Create Certificate...`, you need generate CSR file.
5.	In the `Push Notifications` section click `Create Certificate...` then click `Choose File` upload the CSR file which you created a moment ago.
6.	Then click `Continue` and download the `xx.cer` file.
7.	Double click the `xx.cer` file, and then choose the certificates which you just download amoment ago.
8.	Export the `xx.cer` file as p12 file.(important:remember your password, we will use it in the follow steps.)
9.	Then use the tool `apnsPem.sh` to create apns pem file.

Generate CSR file(CertificateSigningRequest)
============================================

1.	open `Keychain Access` > `Certificate Assistant` > `Request a Certificate from a Certificate Authority`.
	-	In the User Email Address field, enter your email address.
	-	In the Common Name field, create a name for your private key (e.g., John Doe Dev Key).
	-	The CA Email Address field should be left empty.
	-	In the "Request is" group, select the "Saved to disk" option.
2.	Click Continue within Keychain Access to complete the CSR generating process.
