# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Tools for people envious of nvidia's blob driver"
HOMEPAGE="https://github.com/pathscale/envytools"
EGIT_REPO_URI="
	https://github.com/envytools/envytools.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/libxml2
	x11-libs/libpciaccess"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

DOCS=( README.rst )

PATCHES=( "${FILESDIR}"/${PN}-bison.patch )
