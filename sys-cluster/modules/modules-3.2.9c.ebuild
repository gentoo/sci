# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="123"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/modules/files/Modules/${P%[a-z]}/${P}.tar.bz2/download -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

DEPEND="
	dev-lang/tcl
	dev-tcltk/tclx
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%[a-z]}"

DOCS=(ChangeLog README NEWS TODO)

src_configure() {
	local myeconfargs=(
		$(use_with X x)
	)
	autotools-utils_src_configure
}
