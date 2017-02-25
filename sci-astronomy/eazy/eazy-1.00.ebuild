# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Photometric redshift estimator for galaxies"
HOMEPAGE="http://www.astro.yale.edu/eazy/?home"
SRC_URI="http://www.astro.yale.edu/eazy/download/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake -C src
	use doc && emake -C doc
}

src_test() {
	cd inputs
	../src/eazy
	mv zphot.param.default zphot.param
	../src/eazy || die
}

src_install() {
	dobin src/eazy
	insinto /usr/share/eazy
	doins -r templates
	use doc && dodoc doc/eazy_manual.pdf
	if use examples; then
		cd inputs
		rm templates
		insinto /usr/share/doc/${PF}
		doins -r *
	fi
}
