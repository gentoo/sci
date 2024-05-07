# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 autotools

MY_PN="PHOTOS"
MY_P=${MY_PN}.${PV}

DESCRIPTION="Monte Carlo for bremsstrahlung in the decay of particles and resonances"
HOMEPAGE="
	https://gitlab.cern.ch/photospp/photospp
	http://photospp.web.cern.ch/photospp/
"
SRC_URI="https://photospp.web.cern.ch/resources/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples hepmc2 hepmc3 pythia tauola"

RDEPEND="
	hepmc2? ( sci-physics/hepmc:2=[-cm(-),gev(+)] )
	hepmc3? ( sci-physics/hepmc:3=[-cm(-),gev(+)] )
	pythia? ( sci-physics/pythia:8= )
	tauola? ( sci-physics/tauola[hepmc2?,hepmc3?,pythia?] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		app-text/ghostscript-gpl
		app-text/texlive
	)
"
REQUIRED_USE=" || ( hepmc2 hepmc3 )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--without-mc-tester \
		$(use_with hepmc3 hepmc3 "${EPREFIX}/usr") \
		$(use_with hepmc2 hepmc "${EPREFIX}/usr") \
		$(use_with pythia pythia8 "${EPREFIX}/usr") \
		$(use_with tauola tauola "${EPREFIX}/usr")
	# weird autoconf + Makefile
	cat <<-EOF >> make.inc || die
	LDFLAGS += ${LDFLAGS}
	CFLAGS += ${CFLAGS}
	FFLAGS += ${FFLAGS}
	EOF
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
	emake DESTDIR="${D}" install

	if use doc; then
		dodoc documentation/doxy_documentation/html/*
		dodoc documentation/latex_documentation/*.pdf
	fi

	if use examples; then
		dodoc -r examples
	fi
}
