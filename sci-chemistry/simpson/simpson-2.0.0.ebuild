# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils

DESCRIPTION="General-purpose software package for simulation virtually all kinds of solid-state NMR experiments"
HOMEPAGE="http://bionmr.chem.au.dk/bionmr/software/index.php"
SRC_URI="http://bionmr.chem.au.dk/download/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
LICENSE="GPL-2"
IUSE="threads gtk tk"

RDEPEND="
	dev-libs/libf2c
	virtual/blas
	virtual/lapack
	gtk? ( x11-libs/gtk+:1 )
	tk? ( dev-lang/tk )"
DEPEND="${RDEPEND}"

src_prepare() {
	rm -rf f2c missing
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	eautoreconf
}

src_configure(){
# Broken
#		$(use_enable threads parallel) \
	econf \
		--disable-parallel \
		$(use_enable tk tklib) \
		$(use_enable gtk simplot)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc vnmrtools/README.vnmrtools NEWS README TODO AUTHORS || die
}
