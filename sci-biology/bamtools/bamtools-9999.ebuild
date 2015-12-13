# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/pezmaster31/bamtools.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND="
	>=dev-libs/jsoncpp-0.5.0-r1
	<dev-libs/jsoncpp-1
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-unbundle.patch )

src_install() {
	cmake-utils_src_install
	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
