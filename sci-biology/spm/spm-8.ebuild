# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Analysis of brain imaging data sequences for Octave or Matlab"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
SRC_URI="http://www.fil.ion.ucl.ac.uk/spm/download/restricted/idyll/${PN}${PV}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=sci-mathematics/octave-3.6.4
	"

DEPEND="${RDEPEND}
	app-arch/unzip
	"

S="${WORKDIR}/${PN}${PV}"

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
