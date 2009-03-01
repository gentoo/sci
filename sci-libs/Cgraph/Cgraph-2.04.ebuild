# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="A set of C functions that generate PostScript for publication quality scientific plots"
HOMEPAGE="http://neurovision.berkeley.edu/software/A_Cgraph.html"
SRC_URI="http://neurovision.berkeley.edu/software/${PN}${PV}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	cd source
	emake -j1 \
		INCLUDE_DIR=/usr/include \
		LIB_DIR=/usr/$(get_libdir) \
		CC=$(tc-getCC) \
		ARCHS="" \
		CCFLAGS="${CFLAGS}" || \
	die
}
