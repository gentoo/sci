# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/glimmer/glimmer-3.02-r2.ebuild,v 1.3 2010/07/16 17:29:32 hwoarang Exp $

EAPI="2"

inherit eutils

MY_PV=${PV//./}

DESCRIPTION="An HMM-based microbial gene finding system from TIGR"
HOMEPAGE="http://ccb.jhu.edu/software/glimmer"
SRC_URI="http://www.cbcb.umd.edu/software/${PN}/${PN}${MY_PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="app-shells/tcsh
	!app-crypt/pkcrack
	!media-libs/libextractor"

S="${WORKDIR}/${PN}${PV}"

src_prepare() {
	sed -i -e 's|\(set awkpath =\).*|\1 /usr/share/'${PN}'/scripts|' \
		-e 's|\(set glimmerpath =\).*|\1 /usr/bin|' scripts/* || die "failed to rewrite paths"
	# Fix Makefile to die on failure
	sed -i 's/$(MAKE) $(TGT)/$(MAKE) $(TGT) || exit 1/' src/c_make.gen || die
	# GCC 4.3 include fix
	sed -i 's/include  <string>/include  <string.h>/' src/Common/delcher.hh || die
	# avoid file collision on /usr/bin/extract #247394
	epatch "${FILESDIR}/${P}-glibc210.patch"
	epatch "${FILESDIR}/${P}-jobserver-fix.patch"
	epatch "${FILESDIR}/${P}-ldflags.patch"
	epatch "${FILESDIR}/${P}-rename_extract.patch"
}

src_compile() {
	emake -C src || die
}

src_install() {
	rm -f bin/test
	dobin bin/* || die

	insinto /usr/share/${PN}/scripts
	doins scripts/* || die

	dodoc glim302notes.pdf
}
