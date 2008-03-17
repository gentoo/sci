# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="ESO astronomical image visualizer with catalog access."
HOMEPAGE="http://archive.eso.org/skycat"
SRC_URI="ftp://ftp.eso.org/pub/archive/${PN}/Sources/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="threads"

DEPEND=">=dev-tcltk/tclx-2.4
	>=dev-tcltk/blt-2.4
	>=dev-tcltk/itcl-3.3
	>=dev-tcltk/iwidgets-4.0.1
	>=dev-tcltk/tkimg-1.3"


src_unpack() {
	unpack ${A}
	# fix buggy tcl.m4 for bash3
	epatch "${FILESDIR}"/${P}-m4.patch
	# fix old style headers, set as error by new g++
	epatch "${FILESDIR}"/${P}-gcc41.patch
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable threads) \
		|| die "econf failed"
	emake
	# a second time to make sure every dir passed
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README CHANGES VERSION
	for d in tclutil astrotcl rtd cat skycat; do
		docinto ${d}
		dodoc  README CHANGES VERSION
	done
}
