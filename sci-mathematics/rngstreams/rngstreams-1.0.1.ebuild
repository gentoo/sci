# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Multiple independent streams of pseudo-random numbers"
HOMEPAGE="http://statmath.wu.ac.at/software/RngStreams/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-3"

SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"
DEPEND=""
RDEPEND=""

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install ||  die "emake install failed"
	dodoc AUTHORS README NEWS
	insinto /usr/share/doc/${PF}
	if use doc; then
		dohtml -r doc/rngstreams.html/* || die
		doins doc/${PN}.pdf || die
	fi
	if use examples; then
		emake distclean -C examples
		rm -f examples/Makefile*
		doins -r examples
	fi
}
