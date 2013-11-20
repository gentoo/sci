# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

MYPN=MC-TESTER

DESCRIPTION="A universal tool for comparisons of Monte Carlo predictions in High Energy Physics"
HOMEPAGE="http://mc-tester.web.cern.ch/MC-TESTER/"
SRC_URI="http://mc-tester.web.cern.ch/MC-TESTER/${MYPN}-${PV}.tar.gz"
LICENSE="CPC GPL-2+"
#HepMC interface is licensed under GPL, other code under CPC

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples hepmc"

RDEPEND="sci-physics/root
	hepmc? ( sci-physics/hepmc )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MYPN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-compare.sh.patch"
}

src_configure() {
	econf \
		--with-root="/usr" \
		--without-Pythia8 \
		$(use_with hepmc HepMC "/usr")
}

src_compile() {
	emake
	use doc && cd doc && make || die
}

src_install() {
	emake PREFIX="${D}/usr" install
	exeinto /usr/bin
	newexe analyze/compare.sh mc-tester-compare
	insinto /usr/libexec/${PN}/analyze
	doins analyze/*.C analyze/*.tex

	if use doc; then
		dohtml doc/doxygenDocs/html/*
		dodoc doc/{README*,USER-TESTS,tester.ps.gz}
	fi

	use examples && dodoc -r examples-*
}

pkg_postinst() {
	elog "A script to perform an analysis step is installed as /usr/bin/mc-tester-compare"
	elog "it takes two root files with generation results as command line arguments"
}
