# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Collection of scripts to access the CDS databases"
HOMEPAGE="http://cdsweb.u-strasbg.fr/doc/cdsclient.html"
SRC_URI="ftp://cdsarc.u-strasbg.fr/pub/sw/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="app-shells/tcsh"

RESTRICT="nostrip"

src_unpack() {
	unpack ${A}
	# remove non standard "mantex" page
	sed -i \
		-e 's/aclient.tex//' \
		"${S}"/configure || die "sed failed"
	# remove useless version file
	sed -i \
		-e 's/install_shs install_info/install_shs/' \
		"${S}"/Makefile.in || die "sed failed"
}

src_compile() {
	econf || die "econf failed"
	emake C_OPT="${CFLAGS}" || die "emake failed"
}


src_install() {
	dodir /usr/bin
	dodir /usr/share/man
	dodir /usr/$(get_libdir)
	emake \
		PREFIX="${D}"/usr \
		MANDIR="${D}"/usr/share/man \
		LIBDIR="${D}"/usr/$(get_libdir) \
		install || die "emake install failed"
}
