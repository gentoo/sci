# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="OpenIB library that enables Socket Direct Protocol for unmodified applications"
HOMEPAGE="http://www.openfabrics.org/"
OFED_VER="1.3.1"
OFED_P="OFED-${OFED_VER}"
SRC_URI="http://www.openfabrics.org/downloads/OFED/ofed-${OFED_VER}/${OFED_P}.tgz"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A} || die "unpack failed"
	rpm_unpack "${OFED_P}/SRPMS/${P}-1.ofed${OFED_VER}.src.rpm"
	tar xzf "${P}.tar.gz"
}

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README ChangeLog
}

