# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

DESCRIPTION="qgraf generates Feynman diagrams for various types of QFT models"
HOMEPAGE="http://cfif.ist.utl.pt/~paulo/qgraf.html"
SRC_URI="http://anonymous:anonymous@qgraf.tecnico.ulisboa.pt/v$(ver_cut 1-2)/qgraf-${PV}.tgz"
S="${WORKDIR}/${P}.dir"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"
RESTRICT="bindist mirror"

src_compile() {
	sed -i -e 's:gfortran:$(FC) $(FFLAGS) $(LDFLAGS):' Makefile || die
	emake qgraf
}

src_install() {
	dobin ${PN}

	use doc && dodoc *.pdf
	if use examples; then
		docinto examples
		dodoc phi3 qed qcd *.sty *.dat
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
