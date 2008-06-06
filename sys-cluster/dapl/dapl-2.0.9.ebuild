# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 CPL-1.0 )"

KEYWORDS="~x86 ~amd64"

DESCRIPTION="OpenIB - Direct Access Provider Library"
HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/dapl/${P}.tar.gz"
S="${WORKDIR}/${P}-1"

IUSE=""

RDEPEND="sys-cluster/libibverbs
	sys-cluster/librdmacm"
DEPEND="${RDEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
	doman man/*
	insinto /etc
	newins "${FILESDIR}/dat.conf.${PV}" dat.conf
}

