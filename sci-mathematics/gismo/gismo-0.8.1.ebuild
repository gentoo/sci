# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils

DESCRIPTION='C++ library for geometric design and numerical simulation'
HOMEPAGE="https://gs.jku.at/gismo"
SRC_URI="https://github.com/filiatra/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

# Unbundling in progress, 
# preparing local changes to get upstream
DEPEND="
	doc? ( >=app-doc/doxygen-1.8 )"

src_prepare() {
	epatch "${FILESDIR}/examples-CMakeLists.patch"
	epatch "${FILESDIR}/doc-install.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use examples GISMO_BUILD_EXAMPLES)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		# explicitly call optional target doc
		cd "${S}_build" || die "could not find cmake build folder"
		emake doc
	fi
}
