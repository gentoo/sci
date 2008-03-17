# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /CVS/groups/vistech/bgreen-overlay/sys-cluster/openib-userspace/openib-userspace-1.2.ebuild,v 1.1.1.1 2007/10/12 20:18:26 bgreen Exp $

inherit rpm

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

KEYWORDS="~amd64"

DESCRIPTION="OpenFabrics userspace libraries and utilities.  This ebuild is an
all-inclusive alternative to the openib metapackage and dependencies"

HOMEPAGE="http://www.openfabrics.org/"
SHORT_PV=${PV%\.[^.]}
SRC_URI="http://www.openfabrics.org/builds/ofed-${SHORT_PV}/release/OFED-${PV}.tgz"
MY_P="OFED-${PV}"
S="${WORKDIR}/ofa_user-${PV}"
OSM="${S}/src/userspace/management/osm"

IUSE="ehca ipath cxgb3 opensm dapl srptools qlvnictools tvflash mstflint"

DEPEND=""
RDEPEND="${DEPEND}
		 !<=sys-cluster/openib-drivers-1.2
		 !sys-cluster/libibverbs
		 !sys-cluster/libmthca
		 !sys-cluster/libipathverbs
		 !sys-cluster/librdmacm
		 !sys-cluster/libsdp
		 !sys-cluster/dapl
		 !sys-cluster/libehca
		 !sys-cluster/libibcm
		 !sys-cluster/libibcommon
		 !sys-cluster/libibmad
		 !sys-cluster/libibumad
		 !sys-cluster/openib-diags
		 !sys-cluster/openib-files
		 !sys-cluster/openib-osm
		 !sys-cluster/openib-perf
		 !sys-cluster/openib-srptools
		 !sys-cluster/openib"

src_unpack() {
	unpack ${A} || die "unpack failed"
	rpm_unpack ${MY_P}/SRPMS/ofa_user-${PV}-0.src.rpm
	tar xzf ofa_user-${PV}.tgz
}

src_compile() {
	myconf="--with-libibverbs --with-libmthca"
	if use ipath ; then myconf="$myconf --with-libipathverbs"; fi
	if use ehca ; then myconf="$myconf --with-libehca"; fi
	if use cxgb3 ; then myconf="$myconf --with-libcxgb3"; fi
	myconf="$myconf --with-libibcm"
	myconf="$myconf --with-libsdp"
	myconf="$myconf --with-librdmacm"
	myconf="$myconf $(use_with dapl)"
	if use opensm ; then myconf="$myconf --with-management-libs"; fi
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
	emake -j1
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc "${WORKDIR}/${MY_P}/README.txt"
	dodoc "${WORKDIR}/${MY_P}/docs/*"
	if use opensm ; then
		newconfd "${OSM}/scripts/opensm.sysconfig" opensm
		newinitd "${FILESDIR}/opensm.init.d" opensm
		insinto /etc
		doins "${S}/ofed_scripts/opensm.conf"
		dobin "${S}/ofed_scripts/sldd.sh"
	fi
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensm to your start-up scripts:"
	einfo "\`rc-update add opensm default\`"
}

