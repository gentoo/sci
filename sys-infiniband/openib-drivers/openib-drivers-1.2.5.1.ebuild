# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod rpm

DESCRIPTION="OpenIB kernel modules"
HOMEPAGE="http://www.openfabrics.org/"
SHORT_PV=${PV%\.[^.]}
SRC_URI="http://www.openfabrics.org/builds/ofed-${SHORT_PV}/release/OFED-${PV}.tgz"
MY_P="OFED-${PV}"
S="${WORKDIR}/ofa_kernel-${PV}"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="cxgb3 debug ehca hpage-patch ipath iser madeye memtrack rds srp vnic"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/linux-sources
	!sys-infiniband/openib-files"

pkg_setup() {

	CONFIG_CHECK="!INFINIBAND PCI"
	ERROR_INFINIBAND="Infiniband is already compiled into the kernel."
	ERROR_PCI="PCI must be enabled in the kernel."

	linux-mod_pkg_setup
}

src_unpack() {
	unpack ${A} || die "unpack failed"
	rpm_unpack ${MY_P}/SRPMS/ofa_kernel-${PV}-0.src.rpm
	tar xzf ofa_kernel-${PV}.tgz
}

make_target() {
	local myARCH="${ARCH}" myABI="${ABI}"
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"

	emake HOSTCC=$(tc-getBUILD_CC) CC=$(get-KERNEL_CC) $@ \
		|| die "Unable to run emake $@"

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

	CONF_PARAMS="--prefix=${ROOT}usr --kernel-version=${KV_FULL}
				 --with-core-mod
				 --with-ipoib-mod
				 --with-ipoib-cm
				 --with-sdp-mod
				 --with-user_mad-mod
				 --with-user_access-mod
				 --with-addr_trans-mod
				 --with-mthca-mod"
	CONF_PARAMS="$CONF_PARAMS
			     $(use_with srp)-mod
			     $(use_with ipath)_inf-mod
			     $(use_with iser)-mod
			     $(use_with ehca)-mod
			     $(use_with rds)-mod
			     $(use_with madeye)-mod
			     $(use_with vnic)-mod
			     $(use_with cxgb3)-mod"
	if use debug; then
		CONF_PARAMS="$CONF_PARAMS
					 --with-mthca_debug-mod
					 --with-ipoib_debug-mod
					 --with-sdp_debug-mod
					 $(use_with srp)_debug-mod
					 $(use_with rds)_debug-mod
					 $(use_with vnic)_debug-mod
					 $(use_with cxgb3)_debug-mod"
	else
		CONF_PARAMS="$CONF_PARAMS
					 --without-mthca_debug-mod
					 --without-ipoib_debug-mod
					 --without-sdp_debug-mod"
	fi
	ebegin "Configuring"
	local myARCH="${ARCH}" myABI="${ABI}"
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
	./configure ${CONF_PARAMS} ${EXTRA_ECONF} \
		|| die "configure failed with options: ${CONF_PARAMS}"
	ARCH="${myARCH}"
	ABI="${myABI}"
	eend

	#sed -i '/DEPMOD.*=.*depmod/s/=.*/= :/' ./Makefile
	#grep DEPMOD Makefile

	make_target
}

src_install() {

	make_target DESTDIR="${D}" install

	insinto /usr/include/rdma
	doins "${S}/include/rdma/*.h"
	insinto /usr/include/scsi
	doins "${S}/include/scsi/*.h"

	insinto /etc/udev/rules.d
	newins "${S}/ofed_scripts/90-ib.rules" 40-ib.rules
	insinto /etc/modules.d
	newins "${FILESDIR}/openib.modprobe" openib
	insinto /etc/infiniband

	doinitd "${FILESDIR}/openib"

	# build openib.conf based on ofed_scripts/ofa_kernel.spec
	build_ipoib=1
	build_sdp=1
	cp "${S}/ofed_scripts/openib.conf" "${T}"
	IB_CONF_DIR=${T}
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load UCM module" >> ${IB_CONF_DIR}/openib.conf
	echo "UCM_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load RDMA_CM module" >> ${IB_CONF_DIR}/openib.conf
	echo "RDMA_CM_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load RDMA_UCM module" >> ${IB_CONF_DIR}/openib.conf
	echo "RDMA_UCM_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Increase ib_mad thread priority" >> ${IB_CONF_DIR}/openib.conf
	echo "RENICE_IB_MAD=no" >> ${IB_CONF_DIR}/openib.conf

	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load MTHCA" >> ${IB_CONF_DIR}/openib.conf
	echo "MTHCA_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	if use ipath; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load IPATH" >> ${IB_CONF_DIR}/openib.conf
		echo "IPATH_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use ehca; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load eHCA" >> ${IB_CONF_DIR}/openib.conf
		echo "EHCA_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if (( build_ipoib )); then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load IPoIB" >> ${IB_CONF_DIR}/openib.conf
		echo "#IPOIB_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable IPoIB Connected Mode" >> ${IB_CONF_DIR}/openib.conf
		echo "#SET_IPOIB_CM=yes" >> ${IB_CONF_DIR}/openib.conf
		# from ofa_user.spec:
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable IPoIB High Availability daemon" >> ${IB_CONF_DIR}/openib.conf
		echo "#IPOIBHA_ENABLE=no" >> ${IB_CONF_DIR}/openib.conf
		echo "# PRIMARY_IPOIB_DEV=ib0" >> ${IB_CONF_DIR}/openib.conf
		echo "# SECONDARY_IPOIB_DEV=ib1" >> ${IB_CONF_DIR}/openib.conf
	fi
	if (( build_sdp )); then
		 echo >> ${IB_CONF_DIR}/openib.conf
		 echo "# Load SDP module" >> ${IB_CONF_DIR}/openib.conf
		 echo "#SDP_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use srp; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load SRP module" >> ${IB_CONF_DIR}/openib.conf
		echo "#SRP_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
		# from ofa_user.spec:
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable SRP High Availability daemon" >> ${IB_CONF_DIR}/openib.conf
		echo "#SRPHA_ENABLE=no" >> ${IB_CONF_DIR}/openib.conf

	fi
	if use iser; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load ISER module" >> ${IB_CONF_DIR}/openib.conf
		echo "#ISER_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use rds; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load RDS module" >> ${IB_CONF_DIR}/openib.conf
		echo "#RDS_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use vnic; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load VNIC module" >> ${IB_CONF_DIR}/openib.conf
		echo "#VNIC_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi

	doins "${T}/openib.conf"
}

pkg_postinst() {

	linux-mod_pkg_postinst

	einfo "Configuration file installed in /etc/infiniband/openib.conf"
	einfo "To automatically initialize infiniband on boot, add openib to your"
	einfo "start-up scripts, like so:"
	einfo "\`rc-update add openib default\`"

}
