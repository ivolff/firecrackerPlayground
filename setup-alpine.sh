apk add --no-cache openrc
apk add --no-cache util-linux
apk add build-base gcompat
apk add --no-cache g++
apk add --no-cache python2 python3
#apk add --no-cache nano
#apk add --no-cache go


ln -s agetty /etc/init.d/agetty.ttyS0
echo ttyS0 >/etc/securetty
rc-update add agetty.ttyS0 default

echo "root:root" | chpasswd

echo "nameserver 1.1.1.1" >>/etc/resolv.conf

USER_FILE_PATH="/usr/host"
LOOP_FILE_PATH="/usr/host"

echo $2
g++ "${LOOP_FILE_PATH}/hostLoop.cpp" -o "${LOOP_FILE_PATH}/hostLoop" -DEXEC_COMMAND="${2}"
chmod 777 "${LOOP_FILE_PATH}/hostLoop"

cd "${USER_FILE_PATH}"

echo $1

eval $1

#g++ "${USER_FILE_PATH}/user_function.cpp" -o "${USER_FILE_PATH}/user_function"
#chmod 777 "${USER_FILE_PATH}/user_function.py"

cd /

rc-update add devfs boot
rc-update add procfs boot
rc-update add sysfs boot
rc-update add connectionHandler boot

for d in bin etc lib root sbin usr; do tar c "/$d" | tar x -C /my-rootfs; done
for dir in dev proc run sys var tmp; do mkdir /my-rootfs/${dir}; done

chmod 1777 /my-rootfs/tmp

