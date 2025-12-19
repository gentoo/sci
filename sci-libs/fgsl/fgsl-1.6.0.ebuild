# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs fortran-2

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="
	https://doku.lrz.de/display/PUBLIC/FGSL+-+A+Fortran+interface+to+the+GNU+Scientific+Library/
	https://github.com/reinh-bader/fgsl/
"
SRC_URI="https://doku.lrz.de/files/10746505/611614740/11/1738330787047/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND=">=sci-libs/gsl-2.7"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

FORTRAN_STANDARD=90

DOCS=( NEWS README )

src_compile() {
	# With -j higher than 1 we get file not found errors
	emake -j1
	docs_compile
}

src_install() {
	default
	mv "${ED}/usr/share/doc/fgsl" "${ED}/usr/share/doc/${PF}" || die
}
