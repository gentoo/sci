# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="Library for reasoning about floating point numbers in coq."
HOMEPAGE="http://lipforge.ens-lyon.fr/www/pff/"
SRC_URI="http://lipforge.ens-lyon.fr/frs/download.php/147/Float${PV/#????/}-${PV/%????/}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RDEPEND="sci-mathematics/coq"

DEPEND="${RDEPEND}"

S="${WORKDIR}/Float"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s|\`\$(COQC) -where\`/user-contrib| \
		\$(DESTDIR)/\`\$(COQC) -where\`/user-contrib|g" Makefile
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
}

