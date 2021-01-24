# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bloat-free graphical user interface library for C++"
HOMEPAGE="https://github.com/simoncblyth/imgui"
SRC_URI="https://github.com/ocornut/imgui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/glew:0"
DEPEND="${RDEPEND}"

src_install() {
	insinto "/usr/include/${PN}"
	doins *.h
	insinto "/usr/include/${PN}/backend"
	doins backends/*.h
}
