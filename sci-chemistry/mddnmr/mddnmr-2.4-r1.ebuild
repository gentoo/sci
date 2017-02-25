# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MY_P="${PN}${PV}"

DESCRIPTION="Program for processing of NUS multidimensional NMR spectra"
HOMEPAGE="http://www.nmr.gu.se/~mdd/"
SRC_URI="http://pc8.nmr.gu.se/~mdd/Downloads/${MY_P}.tgz"

SLOT="0"
KEYWORDS=""
LICENSE="mddnmr"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-shells/tcsh
	sci-chemistry/nmrpipe"
DEPEND=""

RESTRICT="mirror"

S="${WORKDIR}"/${PN}

QA_PREBUILT="opt/${PN}/.*"

src_install() {
	exeinto /opt/${PN}/com
	doexe com/*

	exeinto /opt/${PN}/bin
	if use amd64; then
		doexe binXeonE5mkl/*
	elif use x86; then
		doexe binUbuntu32Static/*
	fi

	insinto /opt/${PN}/
	doins -r GUI

	cat >> "${T}"/qMDD <<- EOF
	#!${EPREFIX}/bin/csh

	setenv LD_LIBRARY_PATH $(grep LDPATH "${EPREFIX}"/etc/env.d/35intelsdp | sed 's:LDAPATH=::g')"
	setenv MDD_NMR "${EPREFIX}/opt/${PN}"
	setenv MDD_NMRbin "${EPREFIX}/opt/${PN}/bin/"
	set path=( . "\$MDD_NMRbin"  "\${MDD_NMR}/com" \$path )

	csh "${EPREFIX}/opt/${PN}/GUI/qMDD"
	EOF

	dobin "${T}"/qMDD

	dodoc *pdf

	python_optimize "${ED}"
}
