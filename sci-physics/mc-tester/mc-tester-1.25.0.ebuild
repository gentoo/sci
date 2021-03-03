# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYPN="MC-TESTER"

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs

DESCRIPTION="Comparisons of Monte Carlo predictions in High Energy Physics"
HOMEPAGE="http://mc-tester.web.cern.ch/MC-TESTER/"
SRC_URI="http://mc-tester.web.cern.ch/MC-TESTER/${MYPN}-${PV}.tar.gz"

#HepMC interface is licensed under GPL, other code under CPC
LICENSE="CPC GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples hepmc pythia"

RDEPEND="sci-physics/root:=
	hepmc? ( sci-physics/hepmc )
	pythia? ( sci-physics/pythia:8 )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}"

PATCHES=(
	"${FILESDIR}/${P}-compare.sh.patch"
)

src_configure() {
	econf \
		--with-root="${EPREFIX}/usr" \
		$(use_with pythia Pythia8 "${EPREFIX}/usr") \
		$(use_with hepmc HepMC "${EPREFIX}/usr")
}

src_compile() {
	docs_compile
	default
}

src_install() {
	default
	newbin analyze/compare.sh mc-tester-compare

	insinto /usr/libexec/${PN}/analyze
	doins analyze/*.C
	insinto /usr/share/${PN}
	doins analyze/*.tex

	use examples && dodoc -r examples-*
}

pkg_postinst() {
	elog "A script to perform an analysis step is installed as /usr/bin/mc-tester-compare"
	elog "it takes two root files with generation results as command line arguments"
}
