# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB library that provides low layer IB functions for use by the IB diagnostic and management programs. These include MAD, SA, SMP, and other basic IB functions."

HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/management/${P}.tar.gz"

IUSE=""

RDEPEND="sys-cluster/libibcommon
	sys-cluster/libibumad"
DEPEND="${RDEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

