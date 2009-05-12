# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit autotools

DESCRIPTION="a program that will automatically determine values of the anomalous scattering factors"
HOMEPAGE="http://www.gwyndafevans.co.uk/id2.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/chooch/5.0.2/packed/chooch-5.0.2.tar.gz"

LICENSE="ccp4"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X"
RDEPEND="X? ( sci-libs/pgplot )
	 sci-libs/gsl
	 sci-libs/Cgraph
	 virtual/blas
	 virtual/cblas"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	rm -rf cgraph-2.04 gsl-1.4
	cd chooch-5.0.2
	econf \
		$(use_with X x) \
		--with-gsl-prefix="/usr" \
		--with-cgraph-prefix="/usr"

	emake -j1|| die
}
