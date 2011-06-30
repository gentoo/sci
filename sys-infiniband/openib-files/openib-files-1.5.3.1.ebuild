# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

OFED_VER="1.5.3.1"
OFED_SUFFIX="OFED.1.5.3.1."

inherit openib

DESCRIPTION="OpenIB system files"
SCRIPTDIR="${S}/ofed_scripts"
KEYWORDS="~x86 ~amd64"
IUSE="ehca ipath iser mlx4 rds srp vnic"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	einfo "Nothing to configure"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /etc/udev/rules.d
	newins "${SCRIPTDIR}/90-ib.rules" 40-ib.rules
	insinto /etc/modprobe.d
	newins "${FILESDIR}/openib.modprobe" openib.conf
	newenvd "${FILESDIR}/openib.env" 02openib
	insinto /etc/infiniband

	doinitd "${FILESDIR}/openib"

	# build openib.conf based on ofed_scripts/ofa_kernel.spec
	build_ipoib=1
	build_sdp=1
	cp "${SCRIPTDIR}/openib.conf" "${T}"
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
	if use mlx4; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load MLX4 modules" >> ${IB_CONF_DIR}/openib.conf
		echo "MLX4_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
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
	einfo "Configuration file installed in /etc/infiniband/openib.conf"
	einfo "To automatically initialize infiniband on boot, add openib to your"
	einfo "start-up scripts, like so:"
	einfo "\`rc-update add openib default\`"

}
