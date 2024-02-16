# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Computing information projections iteratively"
HOMEPAGE="https://github.com/tom111/cipi"
SRC_URI="https://github.com/tom111/cipi/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

PATCHES=(
	"${FILESDIR}/${P}-boost.patch"
)

src_prepare() {
	cmake_src_prepare
	append-ldflags -Wl,--copy-dt-needed-entries
}

src_configure() {
	mycmakeargs=(
		-DENABLE_DOC=$(usex doc ON OFF)
	)

	cmake_src_configure
}

pkg_postinst() {
	echo ""
	elog "The sample PARAM file has been installed to /usr/share/${PN}-${PV}"
	echo ""
	if use doc; then
		elog "A pdf manual has been installed to /usr/share/${PN}-${PV}"
	fi
}
