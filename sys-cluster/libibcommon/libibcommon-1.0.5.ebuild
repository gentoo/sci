# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~x86 ~amd64"

DESCRIPTION="OpenIB library that provides common utility functions for the IB diagnostic and management tools"
HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/management/${P}.tar.gz"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!sys-cluster/openib-userspace"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

