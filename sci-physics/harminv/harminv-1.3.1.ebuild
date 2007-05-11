# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Extraction of complex frequencies and amplitudes from time series"
HOMEPAGE="http://ab-initio.mit.edu/harminv/"
SRC_URI="http://ab-initio.mit.edu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/lapack"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# --enable-shared gave text realloc on amd64
	# autoreconf with latest which seems ok.
	sed -i \
		-e 's/SHARED(no)/SHARED(yes)/' \
		configure.ac || die "sed failed"
	# eautoreconf does not like it.
	autoreconf -fi || die "autoreconf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYRIGHT NEWS README
}
