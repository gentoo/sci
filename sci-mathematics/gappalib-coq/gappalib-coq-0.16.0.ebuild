# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="This library allows the certificates Gappa generates to be imported by the Coq."
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/28596/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sci-mathematics/gappa
		sci-mathematics/coq
		sci-mathematics/flocq"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i configure -e "s/if test \"\$libdir\" = '\${exec_prefix}\/lib';/ \
		if test \"\$libdir\" = '\${exec_prefix}\/lib' -o "\$libdir" = \"\${prefix}\/lib64\";/g"
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NEWS README AUTHORS
}

