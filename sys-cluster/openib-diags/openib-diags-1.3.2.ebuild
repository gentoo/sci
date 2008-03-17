# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB diagnostic programs and scripts needed to diagnose an IB subnet."

HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/management/infiniband-diags-${PV}.tar.gz"
S="${WORKDIR}/infiniband-diags-${PV}"

IUSE=""

RDEPEND="sys-cluster/libibcommon
	sys-cluster/libibumad
	sys-cluster/libibmad
	sys-cluster/openib-osm"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/diags-perfquery.patch"
}

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

