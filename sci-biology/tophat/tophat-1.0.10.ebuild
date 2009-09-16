# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="A splice junction mapper for short RNA-Seq reads"
HOMEPAGE="http://tophat.cbcb.umd.edu/"
SRC_URI="http://tophat.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="sci-biology/bowtie"

src_prepare() {
	# Edit original Makefile to get rid of a
	# race condition, because of missing dep
	# (more precisely a incorrectly stated dep)
	sed -i -e 's/\$(top_builddir)\/src\///g' src/Makefile.am

	eautoreconf || die
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS INSTALL NEWS README THANKS
}
