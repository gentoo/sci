# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/modules/files/Modules/${P%[a-z]}/${P}.tar.bz2/download -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tclx
	X? ( x11-libs/libX11 )
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%[a-z]}"

DOCS=(ChangeLog README NEWS TODO)

src_prepare() {
	has_version ">=dev-lang/tcl-8.6.0" && epatch "${FILESDIR}/${P}-errorline.patch"
}

src_configure() {
	local myeconfargs=(
		$(use_with X x)
		--prefix=/opt
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dosym ${PV%[a-z]} /opt/Modules/default
}

pkg_postinst() {
	elog "Add this line at the end of your bashrc:"
	elog "[ -f /opt/Modules/default/init/bash ] && source /opt/Modules/default/init/bash"
}
