# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="This library allows the certificates Gappa generates to be imported by the Coq"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/30081/${P}.tar.gz"

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
	epatch "${FILESDIR}"/gappalib-coq-coq84.patch
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NEWS README AUTHORS
}

