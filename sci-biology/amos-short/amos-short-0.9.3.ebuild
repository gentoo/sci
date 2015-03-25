# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="A Modular, Open-Source whole genome assembler with defaults for short reads"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/amos/files/short_read_assembly/0.9.3/AMOS-short.tgz"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/AMOS

src_prepare() {
	epatch "${FILESDIR}"/amos-2.0.8-gcc44.patch
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
