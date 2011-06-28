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
IUSE="cxgb3 debug ehca hpage-patch ipath iser madeye memtrack mlx4 rds srp vnic"

RDEPEND=""
PDEPEND="=sys-infiniband/openib-files-${PV}"
DEPEND="${RDEPEND}
	virtual/linux-sources"

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
	# remove patches that failed for me:
	rm "${S}/kernel_patches/fixes/0050_cxgb3__fix_MSI_X_failure_path" \
		"${S}/kernel_patches/fixes/0051_cxgb3__Use_wild_card_for_PCI_subdevice_ID_match" \
		"${S}/kernel_patches/fixes/0052_cxgb3__Fix_resources_release" \
		"${S}/kernel_patches/fixes/0053_cxgb3__Add_EEH_support" \
		"${S}/kernel_patches/fixes/0054_cxgb3__FW_upgrade" \
		"${S}/kernel_patches/fixes/0055_cxgb3__fix_interaction_with_pktgen" \
		"${S}/kernel_patches/fixes/0056_cxgb3__HW_set_up_updates" \
		"${S}/kernel_patches/fixes/0057_cxgb3__Fix_I_O_synchronization" \
		"${S}/kernel_patches/fixes/0071_cxgb3_Parity_initialization_for_T3C_adapters.patch" \
		"${S}/kernel_patches/fixes/0072_cxgb3_Fix_EEH_missing_softirq_blocking.patch" \
		"${S}/kernel_patches/fixes/z_0010_skb_copy.patch" \
		"${S}/kernel_patches/fixes/z_0040_napi_default.patch"
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
			     $(use_with mlx4)-mod
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
					 $(use_with mlx4)_debug-mod
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

}

pkg_postinst() {

	linux-mod_pkg_postinst

}
