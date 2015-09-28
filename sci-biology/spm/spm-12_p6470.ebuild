# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MY_PV=$(get_major_version)

DESCRIPTION="Analysis of brain imaging data sequences for Octave or Matlab"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
SRC_URI="http://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/${PN}${MY_PV}.zip -> ${P}.zip"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=sci-mathematics/octave-3.8"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/${PN}${PV}/src"

src_prepare() {
	emake distclean PLATFORM=octave
}

src_compile() {
	emake -j1 PLATFORM=octave
}

src_install() {
	emake install PLATFORM=octave
	insinto "$(octave-config --m-site-dir)/${P}"
	doins -r "${WORKDIR}/${PN}${PV}"/*
}
