-- 跨平台编译指令 (脚本作者无需关心)
-- gcc -arch i386 -arch x86_64 -O3 -std=c99 -I/opt/theos/include/ -c -o minirsa64.o minirsa.c && gcc -arch i386 -arch x86_64 -LmacOS -lcrypto -O3 -Wl,-segalign,4000 -framework Foundation -bundle -undefined dynamic_lookup -o minirsa.so minirsa64.o && mv minirsa.so macOS && rm -rf *.o *.so
-- xcrun -sdk iphoneos gcc -arch armv7 -miphoneos-version-min=7.0 -O3 -std=c99 -I/opt/theos/include/ -c -o minirsa.o minirsa.c && xcrun -sdk iphoneos gcc -arch armv7 -LiOS -lcrypto -miphoneos-version-min=7.0 -O3 -Wl,-segalign,4000 -framework Foundation -framework UIKit -bundle -undefined dynamic_lookup -o minirsa.so minirsa.o && mv minirsa.so iOS && rm -rf *.o *.so && ldid -S iOS/minirsa.so

-- 生成 RSA 私钥
-- openssl genrsa -out rsa_private_key.pem 1024
-- 生成 RSA 公钥
-- openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem

local rsa = require "minirsa"
local RSA_PUBLIC_KEY = [[-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3bTBJNQJjY6u7Y5b2eOWws0yW
CGuWPm6MGOSVan65wCrJa5p3q3sodQUDVPotjsknjLlje9E1F7Bx94ZuqTwkvAr6
ieLkgbbeqTCzeJ0AryUXiF3auxFSPdpBoD6nxtEeN8bZwfa/IYzdKyKlbhiQbUMN
qWgmxiPVwupwAML7RQIDAQAB
-----END PUBLIC KEY-----]]
local RSA_PRIV_KEY = [[-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQC3bTBJNQJjY6u7Y5b2eOWws0yWCGuWPm6MGOSVan65wCrJa5p3
q3sodQUDVPotjsknjLlje9E1F7Bx94ZuqTwkvAr6ieLkgbbeqTCzeJ0AryUXiF3a
uxFSPdpBoD6nxtEeN8bZwfa/IYzdKyKlbhiQbUMNqWgmxiPVwupwAML7RQIDAQAB
AoGAc4NXvUKc1mqWY9Q75cwNGlJQEMwMtPlsNN4YVeBTHjdeuqoBBQwA62GGXqrN
QpOBKl79ASGghob8n0j6aAY70PQqHSU4c06c7UlkeEvxJKlyUTO2UgnjjIHb2flR
uW8y3xmjpXAfwe50eAVMNhCon7DBc+XMF/paSVwiG8V+GAECQQDvosVLImUkIXGf
I2AJ2iSOUF8W1UZ5Ru68E8hJoVkNehk14RUFzTkwhoPHYDseZyEhSunFQbXCotlL
Ar5+O+lBAkEAw/PJXvi3S557ihDjYjKnj/2XtIa1GwBJxOliVM4eVjfRX15OXPR2
6shID4ZNWfkWN3fjVm4CnUS41+bzHNctBQJAGCeiF3a6FzA/0bixH40bjjTPwO9y
kRrzSYX89F8NKOybyfCMO+95ykhk1B4BF4lxr3drpPSAq8Paf1MhfHvxgQJBAJUB
0WNy5o+OWItJBGAr/Ne2E6KnvRhnQ7GFd8zdYJxXndNTt2tgSv2Gh6WmjzOYApjz
heC3jy1gkN89NCn+RrECQBTvoqFHfyAlwOGC9ulcAcQDqj/EgCRVkVe1IsQZenAe
rKCWlUaeIKeVkRz/wzb1zy9AVsPC7Zbnf4nrOxJ23mI=
-----END RSA PRIVATE KEY-----]]

print('-----公钥加密私钥解密 start------')
local str = '12345611'
local encryptPubStr = rsa.public_encrypt(str, RSA_PUBLIC_KEY)
if not encryptPubStr then
	print('pub encrypt failed')
end
local decryptPriStr = rsa.private_decrypt(encryptPubStr, RSA_PRIV_KEY)
if not decryptPriStr then
	print('pri decrypt failed')
end
sys.alert('公钥加密私钥解密成功\n'..decryptPriStr)
print('-----公钥加密私钥解密 end------')

print('================================')

print('-----私钥加密公钥解密 start------')
local str='12345611'
local encryptPriStr = rsa.private_encrypt(str, RSA_PRIV_KEY)
if not encryptPriStr then
	print('pri encrypt failed')
end
local decryptPubStr = rsa.public_decrypt(encryptPriStr, RSA_PUBLIC_KEY)
if not decryptPubStr then
	print('pub decrypt failed')
end
sys.alert('私钥加密公钥解密成功\n'..decryptPubStr)
print('-----私钥加密公钥解密 end------')
