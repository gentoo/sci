# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Galaxy redhift Bayesian analyzer"
HOMEPAGE="http://www.astro.phys.ethz.ch/exgal_ocosm/zebra/index.html"
SRC_URI="http://www.astro.phys.ethz.ch/exgal_ocosm/zebra/tar/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="sci-libs/gsl
	sci-libs/lapackpp
	virtual/blas
	virtual/cblas
	virtual/lapack"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myeconfargs+=(
		--with-blas="$(pkg-config --libs blas)"
		--with-cblas="$(pkg-config --libs cblas)"
		--with-lapack="$(pkg-config --libs lapack)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r scripts examples
	fi
}
