# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
CMAKE_IN_SOURCE_BUILD=1
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="command line chart creator"
HOMEPAGE="https://clip-lang.org"
SRC_URI="https://github.com/asmuth/clip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-libs/fribidi
	dev-libs/libfmt
	media-libs/freetype
	media-libs/fontconfig
	media-libs/harfbuzz
	media-libs/libpng
	x11-libs/cairo
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.7-libdir.patch )
