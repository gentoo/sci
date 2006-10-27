# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB library that provides common utility functions for the IB diagnostic and management tools"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/management/${PN}"

IUSE=""

DEPEND=""

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

