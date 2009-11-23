# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

MY_P="${PN}${PV}_Linux"

DESCRIPTION="A direct-method program for SAD/SIR phasing"
HOMEPAGE="http://cryst.iphy.ac.cn/Project/protein/protein-I.html"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${MY_P}.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="ccp4 oasis"
IUSE="examples"

RDEPEND="
	sci-chemistry/arp-warp-bin
	sci-chemistry/ccp4
	sci-chemistry/pymol
	sci-chemistry/solve-resolve-bin
	sci-visualization/gnuplot"
DEPEND="
	sci-libs/ccp4-libs
	sci-libs/mmdb"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	rm bin/{fnp2fp,gnuplot,oasis4-0,seq} || die
	epatch "${FILESDIR}"/${PV}-makefile.patch
}

src_compile() {
	emake \
		-C src \
		F77="$(tc-getFC)" \
		CCP4_LIB="/usr/$(get_libdir)" \
		Linux || die
}

src_install() {
	dobin src/{${PN},fnp2fp} || die

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/*.*sh || die

	exeinto /usr/$(get_libdir)/${PN}/html
	doexe bin/html/* || die

	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples || die
	fi

	cat >> "${T}"/25oasis <<- EOF
	oasisbin="/usr/$(get_libdir)/${PN}"
	EOF

	doenvd "${T}"/25oasis
}
