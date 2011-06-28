# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

MY_P="OFED-${PV}"

DESCRIPTION="OpenFabrics userspace libraries and utilities"
HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/builds/ofed-${PV}/OFED-${PV}.tgz"

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~x86 ~amd64"
IUSE="cxgb3 dapl ehca ipath mstflint opensm qlvnictools srptools tvflash"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-infiniband/openib-drivers-1.2
	!sys-infiniband/libibverbs
	!sys-infiniband/libmthca
	!sys-infiniband/libipathverbs
	!sys-infiniband/librdmacm
	!sys-infiniband/libsdp
	!sys-infiniband/dapl
	!sys-infiniband/libehca
	!sys-infiniband/libibcm
	!sys-infiniband/libibcommon
	!sys-infiniband/libibmad
	!sys-infiniband/libibumad
	!sys-infiniband/openib-diags
	!sys-infiniband/openib-files
	!sys-infiniband/openib-mvapich2
	!sys-infiniband/openib-osm
	!sys-infiniband/openib-perf
	!sys-infiniband/openib-srptools
	!sys-infiniband/openib"

S="${WORKDIR}/ofa_user-${PV}"

src_unpack() {
	unpack ${A} || die "unpack failed"
	rpm_unpack ${MY_P}/SRPMS/ofa_user-${PV}-0.src.rpm
	tar xzf ofa_user-${PV}.tgz
}

src_compile() {
	use ipath && myconf="$myconf --with-libipathverbs"
	use ehca && myconf="$myconf --with-libehca"
	use cxgb3 && myconf="$myconf --with-libcxgb3"
	use opensm && myconf="$myconf --with-management-libs"
	myconf="--with-libibverbs --with-libmthca"
	myconf="$myconf --with-libibcm"
	myconf="$myconf --with-libsdp"
	myconf="$myconf --with-librdmacm"
	myconf="$myconf $(use_with dapl)"
	myconf="$myconf $(use_with opensm)"
	myconf="$myconf --with-openib-diags"
	myconf="$myconf --with-perftest"
	myconf="$myconf $(use_with srptools)"
	myconf="$myconf --with-ipoibtools"
	myconf="$myconf $(use_with qlvnictools)"
	myconf="$myconf $(use_with tvflash)"
	myconf="$myconf $(use_with mstflint)"
	myconf="$myconf --with-sdpnetstat"
	#econf ${myconf} || die "configure failed"
	./configure --prefix=/usr --mandir=/usr/share/man \
		--sysconfdir=/etc \
		${myconf} ${EXTRA_ECONF} || die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc "${WORKDIR}/${MY_P}/README.txt"
	dodoc "${WORKDIR}/${MY_P}/docs/*"
	if use opensm ; then
		newconfd "${FILESDIR}/opensm.conf.d" opensm
		newinitd "${FILESDIR}/opensm.init.d" opensm
	fi
}
