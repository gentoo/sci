# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

ID=28596

DESCRIPTION="Gappa certificate generator to be imported by the Coq"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/${ID}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	sci-mathematics/gappa
	sci-mathematics/coq
	sci-mathematics/flocq"
RDEPEND="${DEPEND}"

src_prepare(){
	sed \
		-i configure \
		-e "s/if test \"\$libdir\" = '\${exec_prefix}\/lib';/ \
		if test \"\$libdir\" = '\${exec_prefix}\/lib' -o "\$libdir" = \"\${prefix}\/lib64\";/g"
}

src_compile(){
	emake DESTDIR="/"
}
