# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="OpenIB kernel modules"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/${P}.tgz"
SRC_URI="http://www.gentooscience.org/${P}.tgz"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/modutils
	sys-cluster/openib-files"
DEPEND="${RDEPEND}
	virtual/linux-sources"

pkg_setup() {

	CONFIG_CHECK="!INFINIBAND PCI"
	ERROR_INFINIBAND="Infiniband is already compiled into the kernel."
	ERROR_PCI="PCI must be enabled in the kernel."

	linux-mod_pkg_setup
}

notused_src_unpack() {
	# patching is currently done by the configure script

	cd "${S}"

	# apply kernel fixes

	# apply backport patches
	THEKERNELVER="KV_MAJOR.KV_MINOR.KV_PATCH"
	if [ -d ${S}/kernel_patches/backport/$THEKERNELVER ]; then
		einfo "Applying patches for $THEKERNELVER kernel"
		eindent
		for p in ${S}/kernel_patches/backport/$THEKERNELVER/*; do
			epatch $p
		done
		eoutdent
	fi

	# apply fixes
	einfo "Applying fixes"
	eindent
	for p in ${S}/kernel_patches/fixes/*; do
		epatch $p
	done
	eoutdent

	# Apply huge pages patch
	epatch "${S}/kernel_patches/hpage_patches/hpages.patch"

	# Apply memtrack patch
	[ "$OPENIB_MEMTRACK"="1" ] && $epatch "${S}/kernel_patches/memtrack/memtrack.patch"
}

make_target() {
	local myARCH="${ARCH}" myABI="${ABI}"
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
	CC_HOSTCC=$(tc-getBUILD_CC)
	CC_CC=$(tc-getCC)

	emake HOSTCC=${CC_HOSTCC} CC=${CC_CC} $@ \
		|| die "Unable to run emake kernel"

	ARCH="${myARCH}"
	ABI="${myABI}"
}

src_compile() {
	convert_to_m Makefile

	export CONFIG_INFINIBAND="m"
	export CONFIG_INFINIBAND_IPOIB="m"
	export CONFIG_INFINIBAND_SDP="m"
	export CONFIG_INFINIBAND_SRP="m"

	export CONFIG_INFINIBAND_USER_MAD="m"
	export CONFIG_INFINIBAND_USER_ACCESS="m"
	export CONFIG_INFINIBAND_ADDR_TRANS="y"
	export CONFIG_INFINIBAND_MTHCA="m"
	export CONFIG_INFINIBAND_IPATH="m"

	CONF_PARAMS="--prefix=${ROOT}usr --without-userlevel --kernel-version=${KV_FULL}"
	if [[ "$OPENIB_MEMTRACK" = "1" ]]; then
		CONF_PARAMS="${CONF_PARAMS} --with-memtrack"
	fi

	./configure ${CONF_PARAMS} || die "configure failed with options: ${CONF_PARAMS}"

	sed -i '/DEPMOD.*=.*depmod/s/=.*/= :/' ./Makefile
	grep DEPMOD Makefile

	make_target kernel
}

src_install() {

	#make DESTDIR="${D}" install_kernel || die "install failed"
	make_target DESTDIR="${D}" install_modules \
		|| die "install failed"

	# mv the drivers somewhere they won't be killed by the kernel's make modules_install
	mv ${D}/lib/modules/${KV_FULL}/kernel/drivers/infiniband ${D}/lib/modules/${KV_FULL}/infiniband
	rmdir ${D}/lib/modules/${KV_FULL}/kernel/drivers &> /dev/null
	rmdir ${D}/lib/modules/${KV_FULL}/kernel &> /dev/null
	mkdir -p ${D}/usr/include/rdma
	cp -a ${S}/include/rdma/*.h ${D}/usr/include/rdma
	mkdir -p ${D}/usr/include/scsi
	cp -a ${S}/include/scsi/srp.h ${D}/usr/include/scsi
}

pkg_postinst() {

	linux-mod_pkg_postinst

}
