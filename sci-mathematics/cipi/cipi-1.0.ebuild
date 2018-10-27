# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Computing information projections iteratively"
HOMEPAGE="http://github.com/tom111/cipi"
SRC_URI="https://github.com/tom111/cipi/archive/1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-libs/boost
	doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README"

CMAKE_IN_SOURCE_BUILD="yes"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	echo ""
	elog "The sample PARAM file has been installed to /usr/share/${PN}-${PV}"
	echo ""
	if use doc; then
		elog "A pdf manual has been installed to /usr/share/${PN}-${PV}"
	fi
}
