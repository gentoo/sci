# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV_MAJ=$(ver_cut 1)
MY_PV_REL=$(ver_cut 3)
DESCRIPTION="Analysis of brain imaging data sequences for Octave or Matlab"
HOMEPAGE="http://www.fil.ion.ucl.ac.uk/spm/"
SRC_URI="https://github.com/${PN}/${PN}${MY_PV_MAJ}/archive/r${MY_PV_REL}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=sci-mathematics/octave-3.8"
DEPEND="${RDEPEND}
	app-arch/unzip
"

MY_PN="${PN}${MY_PV_MAJ}-r${MY_PV_REL}"
S="${WORKDIR}/${MY_PN}/src"

src_prepare() {
	default
	emake distclean PLATFORM=octave
}

src_compile() {
	emake PLATFORM=octave
}

src_install() {
	emake install PLATFORM=octave
	insinto "$(octave-config --m-site-dir)/${P}"
	doins -r "${WORKDIR}/${MY_PN}"/*
}
