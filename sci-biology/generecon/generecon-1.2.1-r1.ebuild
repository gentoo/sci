# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Generecon performs linkage disequilibrium gene mapping based on coalescent theory using Bayesian Markov Chain Monte Carlo methods."
HOMEPAGE="http://www.daimi.au.dk/~mailund/GeneRecon/"
SRC_URI="http://www.daimi.au.dk/~mailund/GeneRecon/download/${P}.tar.gz"
SLOT="0"

# License of the package.  This must match the name of file(s) in
# /usr/portage/licenses/.  For complex license combination see the developer
# docs on gentoo.org for details.
LICENSE="GPL-2"

KEYWORDS="x86"

DEPEND="dev-scheme/guile
        sci-libs/gsl"

src_unpack() {
	unpack ${A}
	sed 's|#PF#|'${PF}'|g' ${FILESDIR}/${PN}-docfiles.patch > ${PN}-docfiles.patch

	epatch ${PN}-docfiles.patch

	cd ${S}
	pwd
	einfo "Regenerating autotools files..."
	aclocal || die "aclocal failed"
	automake || die "automake failed"
}

src_install() {
	make DESTDIR=${D} install  || die "make install failed"
}
