# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fortran toolchain-funcs

# we need libg2c for gfortran # 136988
FORTRAN="ifc"

DESCRIPTION="Combined assignment and dynamics algorithm for NMR applications"
HOMEPAGE="http://www.las.jp/english/products/s08_cyana/index.html"
SRC_URI="cyana-2.1.tar"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-typo.patch
	epatch "${FILESDIR}"/${PV}-exec.patch

	cat >> etc/config <<- EOF
	VERSION=${PV}
	SHELL=${EPREFIX}/bin/sh
	FC=${FORTRANC}
	FFLAGS=${FFLAGS}
	FFLAGS2=${FFLAGS}
	CC=$(tc-getCC)
	FORK=g77fork.o
	LDFLAGS=${LDFLAGS}
	LIBS=-pthread -lpthread -liomp5
	EOF

	if [[ ${FORTRANC} == gfortran ]]; then
		cat >> etc/config <<- EOF
		DEFS=-Dgfortran
		SYSTEM=gfortran
		EOF
	else
		cat >> etc/config <<- EOF
		DEFS=-Dintel
		SYSTEM=intel
		EOF
	fi
}

src_compile() {
	cd src
	emake \
		|| die
}

src_install() {
	source etc/config
	dobin cyana{job,table,filter,clean} || die
	newbin src/${PN}/${PN}exe.${SYSTEM} ${PN} || die
	insinto /usr/share/${PN}
	doins -r lib macro help || die
	use examples && doins -r demo

	cat >> "${T}"/20cyana <<- EOF
	CYANALIB="${EPREFIX}/usr/share/${PN}"
	EOF

	doenvd "${T}"/20cyana || die
}
