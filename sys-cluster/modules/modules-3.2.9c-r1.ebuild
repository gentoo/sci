# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Dynamic modification of a user's environment via modulefiles."
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/modules/files/Modules/${P%[a-z]}/${P}.tar.bz2/download -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X"

DEPEND="
	dev-lang/tcl
	dev-tcltk/tclx
	X? ( x11-libs/libX11 )
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%[a-z]}"

DOCS=(ChangeLog README NEWS TODO)

pkg_setup() {
	export MODULES_PATH=/etc/Modules
	export MODULES_VERSION="3.2.9"
}

src_configure() {
	local myeconfargs=(
		$(use_with X x)
		--with-module-path=${MODULES_PATH}/${MODULES_VERSION}/modulefiles
		--with-version-path=${MODULES_PATH}/${MODULES_VERSION}/versions
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dosym ${MODULES_PATH}/${MODULES_VERSION} ${MODULES_PATH}/default
}

pkg_postinst() {
	elog "Add this line at the end of your bashrc:"
	elog "[ -e \"${MODULES_PATH}/default/init/bash\" ] && . \"${MODULES_PATH}/default/init/bash\""
}
