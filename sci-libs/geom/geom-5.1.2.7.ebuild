# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="A complete OpenCascade - OCAF based CAD framework"
HOMEPAGE="http://sourceforge.net/projects/salomegeometry/"
SRC_URI="mirror://sourceforge/salomegeometry/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/opencascade:*"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/adm/lin/

src_prepare() {
	eautoreconf
	ln -fs {../../src,../../inc,../../resources} . || die 'linking failed'
}

src_compile() {
	default
	if use doc ; then
		cd ../../doc/src || die
		doxygen || die 'doxygen failed'
	fi
}

src_install() {
	default
	use doc && dohtml -r ../../doc/html/*
}
