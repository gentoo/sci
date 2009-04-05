# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="This library allows the certificates Gappa generates to be imported by the Coq."
HOMEPAGE="http://lipforge.ens-lyon.fr/www/gappa/"
SRC_URI="http://lipforge.ens-lyon.fr/frs/download.php/151/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RDEPEND="sci-mathematics/gappa
		sci-mathematics/coq"

DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${A}
	cd ${S}

	sed -i configure -e "s/if test \"\$libdir\" = '\${exec_prefix}\/lib';/ \
		if test \"\$libdir\" = '\${exec_prefix}\/lib' -o "\$libdir" = \"\${prefix}\/lib64\";/g"
}

src_compile(){
	econf || die "econf failed"
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NEWS README AUTHORS
}

