# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MYPN=TAUOLA

DESCRIPTION="Tau decay Monte Carlo generator"
HOMEPAGE="http://tauolapp.web.cern.ch/tauolapp/"
SRC_URI="http://tauolapp.web.cern.ch/tauolapp/resources/${MYPN}.${PV}/${MYPN}.${PV}.tar.gz"

#HepMC interface is licensed under GPL, other code under CPC
LICENSE="CPC GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples hepmc tau-spinner"

RDEPEND="
	hepmc? ( sci-physics/hepmc )
	tau-spinner? ( sci-physics/lhapdf )
"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		app-text/ghostscript-gpl
		app-text/texlive
	)
"

S="${WORKDIR}/${MYPN}"

PATCHES=(
	"${FILESDIR}"/${P}-doc.patch
	"${FILESDIR}"/${PN}-1.1.4-makefile.patch
	"${FILESDIR}"/${PN}-1.1.3-tau-spinner-makefile.patch
)

src_configure() {
	econf \
		--without-mc-tester \
		--without-pythia8 \
		$(use_with hepmc hepmc "${EPREFIX}/usr") \
		$(use_with tau-spinner) \
		$(use_with tau-spinner lhapdf "${EPREFIX}/usr")
}

src_compile() {
	emake -j1
	if use doc; then
		cd "${S}/documentation/doxy_documentation" || die
		default
		cd "${S}/documentation/latex_documentation" || die
		default
	fi
}

src_install() {
	emake PREFIX="${D}/usr" install

	if use doc; then
		dohtml documentation/doxy_documentation/html/*
		dodoc documentation/latex_documentation/Tauola_interface_design.pdf
	fi

	if use examples; then
		dodoc -r examples
		use tau-spinner && docinto tau-spinner && dodoc -r TauSpinner/examples
	fi
}
