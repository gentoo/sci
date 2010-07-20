# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils git

DESCRIPTION="cipi is computing information projections iteratively"
HOMEPAGE="http://github.com/tom111/cipi"
EGIT_REPO_URI="git://github.com/tom111/cipi.git"
EGIT_COMMIT="${PV}"
CMAKE_IN_SOURCE_BUILD="yes"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="dev-libs/boost
		doc? ( virtual/latex-base )"

DOCS="AUTHORS README"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	elog " "
	elog "The sample PARAM file has been installed to /usr/share/${PN}-${PV}"
	elog " "
	if use doc; then
		elog "A pdf manual has been installed to /usr/share/${PN}-${PV}"
	fi
}