# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

MY_PN="TAUOLA"
MY_P=${MY_PN}.${PV}

DESCRIPTION="Tau decay Monte Carlo generator"
HOMEPAGE="http://tauolapp.web.cern.ch/"
SRC_URI="https://tauolapp.web.cern.ch/resources/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+hepmc3 +lhapdf doc examples hepmc2 pythia tau-spinner"
REQUIRED_USE=" || ( hepmc2 hepmc3 ) tau-spinner? ( lhapdf )"

RDEPEND="
	hepmc2? ( sci-physics/hepmc:2=[-cm(-),gev(+)] )
	hepmc3? ( sci-physics/hepmc:3=[-cm(-),gev(+)] )
	pythia? ( sci-physics/pythia:8= )
	lhapdf? ( sci-physics/lhapdf )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		app-text/ghostscript-gpl
		app-text/texlive
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.8-tau-spinner-makefile-install.patch
)

src_configure() {
	econf \
		$(use_with lhapdf) \
		$(use_with tau-spinner) \
		$(use_with pythia pythia8 "${EPREFIX}/usr") \
		$(use_with hepmc2 hepmc "${EPREFIX}/usr") \
		$(use_with hepmc3 hepmc3 "${EPREFIX}/usr") \
		--without-mc-tester
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
		docinto tau-spinner && dodoc -r TauSpinner/examples
	fi
}
