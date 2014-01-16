# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Tools for people envious of nvidia's blob driver"
HOMEPAGE="https://github.com/pathscale/envytools"
EGIT_REPO_URI="
	git://github.com/pathscale/envytools.git
	https://github.com/pathscale/envytools.git"

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

DOCS=( README )

PATCHES=( "${FILESDIR}"/${PN}-bison.patch )
