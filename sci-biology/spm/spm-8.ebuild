# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Analysis of brain imaging data sequences for Octave or Matlab"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
URI_BASE="http://www.fil.ion.ucl.ac.uk/spm/download/restricted/idyll/"
SRC_URI="${URI_BASE}${PN}${PV}.zip"

LICENSE="GPL-2+"
SLOT="8"
KEYWORDS=""

RDEPEND=">=sci-mathematics/octave-3.6.4
	"

DEPEND="${RDEPEND}
	"


S=${WORKDIR}/${PN}${PV}

src_prepare() {
	echo "MEXOPTS += -v" >> src/Makefile.var
	emake -C src distclean PLATFORM=octave
	emake -C src toolbox-distclean PLATFORM=octave
}

src_compile() {
	emake -C src -j1 PLATFORM=octave
	emake -C src toolbox PLATFORM=octave
}

src_install() {
	emake -C src -j1 install PLATFORM=octave
	emake -C src -j1 toolbox-install PLATFORM=octave
	insinto $(octave-config --m-site-dir)
	doins -r "${S}"/*.m
}
