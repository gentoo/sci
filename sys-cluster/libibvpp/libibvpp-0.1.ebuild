# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="NOSA BSD-2"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="libibvpp is a C++ wrapper around libibverbs, which is part of OpenIB."
HOMEPAGE="http://opensource.arc.nasa.gov/software/libibvpp/"
SRC_URI="http://opensource.arc.nasa.gov/static/downloads/libibvpp-${PV}.tar.gz"

IUSE=""

DEPEND="|| ( sys-cluster/libibverbs sys-cluster/openib-userspace )"
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS COPYING ChangeLog
}

