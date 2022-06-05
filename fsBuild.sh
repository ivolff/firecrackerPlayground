#umount /tmp/my-rootfs
#rm rootfs.ext4

FUNC_NAME=$1
FUNC_FILE_PATH=$2
EXEC_COMPILE=$3
EXEC_UP=$4

FUNCTION_FILE_NAME="$(basename -- $FUNC_FILE_PATH)"

echo $FUNCTION_FILE_NAME

rm fss/$FUNC_NAME.ext4
dd if=/dev/zero of=fss/$FUNC_NAME.ext4 bs=1M count=1000
mkfs.ext4 fss/$FUNC_NAME.ext4
chmod 777 fss/$FUNC_NAME.ext4
mkdir -p /tmp/rootfs
mount fss/$FUNC_NAME.ext4 /tmp/rootfs

#docker build -t tmp .

echo "/usr/setup-alpine.sh '$EXEC_COMPILE' '\"$EXEC_UP\"'" > IamRetard.sh

docker run -i \
    -v /tmp/rootfs:/my-rootfs \
    -v $FUNC_FILE_PATH:/usr/host/$FUNCTION_FILE_NAME \
    -v $(pwd)/FC:/usr/host\
    -v $(pwd)/FC/connectionHandler:/etc/init.d/connectionHandler\
    -v $(pwd)/setup-alpine.sh:/usr/setup-alpine.sh\
    alpine sh <IamRetard.sh


rm IamRetard.sh
umount /tmp/rootfs

