# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Bloat-free graphical user interface library for C++"
HOMEPAGE="https://github.com/simoncblyth/imgui"

EGIT_REPO_URI="https://github.com/simoncblyth/imgui.git"
EGIT_COMMIT="5df810970fcbd9d96982801745b6340c31b68478"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

RDEPEND="media-libs/glew:0"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.48-pkgconfig.patch )
