# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_P=cgx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="http://www.dhondt.de/${MY_P}.all.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# nptl removed since I cannot work around it
IUSE="doc examples"

RDEPEND="media-libs/mesa[nptl]
	>=media-libs/freeglut-1.0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libSM
	x11-libs/libICE"
DEPEND="${RDEPEND}
	doc? ( app-text/ghostscript-gpl )"

S=${WORKDIR}/CalculiX/${MY_P}/src/

PATCHES=(
	"${FILESDIR}"/01_${MY_P}_Makefile_custom_cxx_flags.patch
	"${FILESDIR}"/02_${MY_P}_menu_fix-freeglut_2.8.1.patch
)

src_configure () {
	# Does not compile without -lpthread
	export PTHREAD="-lpthread"
	export LFLAGS="-L/usr/$(get_libdir) ${LFLAGS}"
}

src_install () {
	dobin cgx

	if use doc; then
		dodoc "${DISTDIR}/${MY_P}.pdf"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/../examples/*
	fi
}
