# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

SLOT="0"
LICENSE="NOSA BSD-2"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="libibvpp is a C++ wrapper around libibverbs, which is part of OpenIB."
HOMEPAGE="http://opensource.arc.nasa.gov/software/libibvpp/"
SRC_URI="http://opensource.arc.nasa.gov/static/opensource/downloads/${P}.tar.gz"

IUSE=""

DEPEND="|| ( sys-infiniband/libibverbs sys-infiniband/openib-userspace )"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
}
