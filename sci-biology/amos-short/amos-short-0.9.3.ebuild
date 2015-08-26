# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A Modular, Open-Source whole genome assembler with defaults for short reads"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/amos/files/short_read_assembly/${PV}/AMOS-short.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/AMOS

src_prepare() {
	epatch "${FILESDIR}"/amos-2.0.8-gcc44.patch
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install
}
