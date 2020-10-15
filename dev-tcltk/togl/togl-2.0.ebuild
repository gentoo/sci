# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="Togl${PV}"

DESCRIPTION="Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="2.0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +threads"

RDEPEND="
	dev-lang/tk:0
	virtual/opengl
"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

src_configure() {
	local myconf=(
		$(use_enable debug symbols)
		$(use_enable amd64 64bit)
		$(use_enable threads)
	)
	econf ${myconf[@]}
}

src_install() {
	default
	rm "${ED}"/usr/include/* || die
	insinto /usr/include/${PN}-${SLOT}
	doins togl*.h
}
