# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Allows the certificates Gappa generates to be imported by Coq"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/30081/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sci-mathematics/gappa
	sci-mathematics/coq
	sci-mathematics/flocq"
RDEPEND="${DEPEND}"

src_prepare(){
	sed \
		-e "s/if test \"\$libdir\" = '\${exec_prefix}\/lib';/ \
		if test \"\$libdir\" = '\${exec_prefix}\/lib' -o "\$libdir" = \"\${prefix}\/lib64\";/g" \
		-i configure || die

	epatch "${FILESDIR}"/gappalib-coq-coq84.patch
}

src_compile(){
	emake DESTDIR="/"
}
