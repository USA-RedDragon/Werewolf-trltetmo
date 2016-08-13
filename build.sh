#!/bin/bash

export kernel=Werewolf
export device=trltetmo
export deviceconfig=werewolf_defconfig
export outdir=/usr/share/nginx/html/Werewolf
export makeopts="-j$(nproc)"
export zImagePath="arch/arm/boot/zImage"
export KBUILD_BUILD_USER=USA-RedDragon
export KBUILD_BUILD_HOST=EdgeOfCreation
export CROSS_COMPILE="ccache /root/deso/prebuilts/gcc/linux-x86/arm/arm-eabi-5.4-gnu/bin/arm-eabi-"
export ARCH=arm

export version=$(cat version)

if [[ $1 =~ "clean" ]] ; then
	make clean
	make mrproper
fi

make ${makeopts} ${deviceconfig}
make ${makeopts}

./dtbTool -o zip/dtb -s 4096 -p scripts/dtc/ arch/arm/boot/

if [ -a ${zImagePath} ] ; then
	cp ${zImagePath} zip/zImage
	find -name '*.ko' -exec cp -av {} zip//modules/ \;
	cd zip
	zip -q -r ${kernel}-${device}-${version}.zip anykernel.sh  META-INF tools zImage dtb
else
	echo -e "\n\e[31m***** Build Failed *****\e[0m\n"
fi

if ! [ -d ${outdir} ] ; then
	mkdir ${outdir}
fi

if [ -a ${kernel}-${device}-${version}.zip ] ; then
	mv -v ${kernel}-${device}-${version}.zip ${outdir}
fi

rm -f zip/zImage
rm -f zip/dtb
