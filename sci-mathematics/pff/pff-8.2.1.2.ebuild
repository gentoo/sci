# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Library for reasoning about floating point numbers in coq"
HOMEPAGE="http://lipforge.ens-lyon.fr/www/pff/"
SRC_URI="http://lipforge.ens-lyon.fr/frs/download.php/147/Float${PV/%????/}-${PV/#????/}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sci-mathematics/coq"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Float"

src_prepare() {
	sed \
		-e "s|\`\$(COQC) -where\`/user-contrib|\$(DESTDIR)/\`\$(COQC) -where\`/user-contrib|g" \
		-i Makefile || die
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"
}
