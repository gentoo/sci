# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="Togl-${PV}"

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug +threads"

RDEPEND="
	dev-lang/tk:0
	virtual/opengl"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable amd64 64bit) \
		$(use_enable threads)
}

src_install() {
	default
	rm "${D}"/usr/include/* || die
	insinto /usr/include/${PN}-${SLOT}
	doins togl*.h
}
