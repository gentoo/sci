# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils

DESCRIPTION="A complete OpenCascade - OCAF based CAD framework"
HOMEPAGE="http://sourceforge.net/projects/salomegeometry/"
SRC_URI="mirror://sourceforge/salomegeometry/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/opencascade"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/adm/lin/

src_prepare() {
	eautoreconf
	ln -fs {../../src,../../inc,../../resources} . || die 'linking failed'
}

src_compile() {
	emake || die 'emake failed'
	if use doc ; then
		cd ../../doc/src
		doxygen || die 'doxygen failed'
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
	use doc && dohtml -r ../../doc/html/*
}
