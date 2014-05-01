# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"

REL="24Sep2012"
MY_P="${PN}${PV}"

DESCRIPTION="Program for processing of non-uniformly sampled (NUS) multidimensional NMR spectra"
HOMEPAGE="http://www.nmr.gu.se/~mdd/"
SRC_URI="http://pc8.nmr.gu.se/~mdd/Downloads/arch/${MY_P}_${REL}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="mddnmr"
IUSE=""

RDEPEND="
	app-shells/tcsh
	sci-chemistry/nmrpipe"
DEPEND=""

RESTRICT="mirror"

S="${WORKDIR}"/${MY_P}

QA_PREBUILT="opt/${PN}/.*"

src_install() {
	exeinto /opt/${PN}/com
	doexe com/*

	exeinto /opt/${PN}/bin
	if use amd64; then
		doexe binLinux64Static/*
	elif use x86; then
		doexe binLinux32Static/*
	fi

	insinto /opt/${PN}/
	doins -r GUI

	cat >> "${T}"/qMDD <<- EOF
	#!${EPREFIX}/bin/csh

	setenv MDD_NMR "${EPREFIX}/opt/${PN}"
	setenv MDD_NMRbin "${EPREFIX}/opt/${PN}/bin/"
	setenv path=( . "$MDD_NMRbin"  "${MDD_NMR}/com" )

	csh "${EPREFIX}/opt/${PN}/GUI/qMDD"
	EOF

	dobin "${T}"/qMDD

	dodoc *pdf
}
