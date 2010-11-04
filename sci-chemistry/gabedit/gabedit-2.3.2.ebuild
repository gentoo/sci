# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs versionator

MY_PN=${PN/g/G}
MY_PV=$(delete_all_version_separators)
MY_P="${MY_PN}Src${MY_PV}"

DESCRIPTION="GUI for computational chemistry packages"
HOMEPAGE="http://gabedit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/GabeditDevloppment/${MY_PN}${MY_PV}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND=">=x11-libs/gtk+-2.4
	x11-libs/gtkglext
	x11-libs/gl2ps
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	sed -e "/GTK_DISABLE_DEPRECATED/s:define:undef:g" \
		-i "${S}/Config.h" || die
	cp "${FILESDIR}"/CONFIG.Gentoo "${S}"/CONFIG

	if use openmp && tc-has-openmp; then
		cat <<- EOF >> "${S}/CONFIG"
			OMPLIB=-L/usr/$(get_libdir) -lgomp
			OMPCFLAGS=-DENABLE_OMP -fopenmp
		EOF
	fi
	echo "COMMONCFLAGS = ${CFLAGS} -DENABLE_DEPRECATED \$(OMPCFLAGS) \$(DRAWGEOMGL)" >> CONFIG
}

src_compile() {
	emake external_gl2ps=1 || die
}

src_install() {
	dobin ${PN} || die
	dodoc ChangeLog || die
}
