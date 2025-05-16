# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs fortran-2

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="https://doku.lrz.de/display/PUBLIC/FGSL+-+A+Fortran+interface+to+the+GNU+Scientific+Library/"
SRC_URI="https://doku.lrz.de/download/attachments/43321199/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="static-libs"

RDEPEND=">=sci-libs/gsl-2.4"
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
