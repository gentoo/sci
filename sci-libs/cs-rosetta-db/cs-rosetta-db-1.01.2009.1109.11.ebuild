# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit flag-o-matic toolchain-funcs

DESCRIPTION="System for chemical shifts based protein structure prediction using ROSETTA"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/CSROSETTA/"
SRC_URI="
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/PDBH.tar.Z -> ${P}-PDBH.tar.Z
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/hybrid/PDBH.hyb.tar.gz ->  ${P}-PDBH.hyb.tar.gz
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/CS.tar.Z -> ${P}-CS.tar.Z
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/hybrid/CS.hyb.tar.gz -> ${P}-CS.hyb.tar.gz
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/ANGLESS.tar.Z -> ${P}-ANGLESS.tar.Z
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/hybrid/ANGLESS.hyb.tar.gz -> ${P}-ANGLESS.hyb.tar.gz
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/hybrid/vall.dat.apr24.gz -> ${P}-vall.dat.apr24.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="binchecks mirror strip"

S="${WORKDIR}"

src_unpack() {
	local i
	unpack ${P}-{PDBH,CS,ANGLESS}.hyb.tar.gz

	for i in *; do
		mv -v ${i}{,.hyb} || die
	done

	unpack ${P}-vall.dat.apr24.gz
	mv ${P}-vall.dat.apr24 vall.dat.apr24 || die

	unpack ${P}-{PDBH,CS,ANGLESS}.tar.Z
}

src_prepare() {
	cat >> "${T}"/39${PN} <<- EOF
	CS_DIR="${EPREFIX}/opt/${PN}/CS"
	CSHYB_DIR="${EPREFIX}/opt/${PN}/CS"
	PDBH_DIR="${EPREFIX}/opt/${PN}/PDBH"
	PDBHYB_DIR="${EPREFIX}/opt/${PN}/PDBH"
	PDBH_TAB="${EPREFIX}/opt/${PN}/PDBH/resolution.tab"
	ANGLESS_DIR="${EPREFIX}/opt/${PN}/ANGLESS"
	ANGLESSHYB_DIR="${EPREFIX}/opt/${PN}/ANGLESS"
	EOF
}

src_install() {
	insinto /opt/${PN}/
	doins -r *
	doenvd "${T}"/39${PN}
}
