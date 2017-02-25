# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils check-reqs fortran-2 versionator

MYP=${PN}_dev_v$(replace_version_separator 2 '')

DESCRIPTION="Photometric Analysis for Redshift Estimate for galaxies"
HOMEPAGE="http://www.cfht.hawaii.edu/~arnouts/LEPHARE/lephare.html"
SRC_URI="http://www.cfht.hawaii.edu/~arnouts/LEPHARE/DOWNLOAD/${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

S="${WORKDIR}/${PN}_dev/source"

CHECKREQS_DISK_BUILD="400M"

src_prepare() {
	export LEPHAREDIR="${WORKDIR}/${PN}_dev" LEPHAREWORK="${WORKDIR}"
	# clean up mac left over crap
	find . -name ._\* -delete || die
	# respect user flags and compiler
	sed -i -e '/^FC/d' -e '/^FFLAGS/d' Makefile || die
}

src_test() {
	# from pdf manual
	cd ${LEPHAREDIR}/test || die
	${LEPHAREDIR}/source/sedtolib -t S -c ../config/zphot.para || die
	${LEPHAREDIR}/source/sedtolib -t Q -c ../config/zphot.para || die
	${LEPHAREDIR}/source/sedtolib -t G -c ../config/zphot.para || die
	${LEPHAREDIR}/source/filter -c ../config/zphot.para || die
	${LEPHAREDIR}/source/mag_star -c ../config/zphot.para || die
	${LEPHAREDIR}/source/mag_gal -t Q -c ../config/zphot.para -EB_V 0. || die
	${LEPHAREDIR}/source/mag_gal -t G -c ../config/zphot.para -MOD_EXTINC 4,8 -LIB_ASCII YES || die
	${LEPHAREDIR}/source/zphota -c ../config/zphot.para || die
}

src_install() {
	# FILES target in Makefile
	dobin \
		sedtolib \
		filter \
		filter_info \
		filter_extinc \
		mag_star \
		mag_gal \
		zphota \
		mag_zform
	dodoc README_TECH
	insinto /usr/share/${PN}
	cd .. || die
	doins -r {ext,filt,config,opa,sed,simul,test,tools,vega}
	echo "LEPHAREDIR=${EPREFIX}/usr/share/${PN}" > 99lephare
	doenvd 99lephare
	newdoc INSTALL README
	use doc && dodoc doc/*.pdf
}
