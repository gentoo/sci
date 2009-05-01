# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="Why is a software verification platform."
HOMEPAGE="http://why.lri.fr/"
SRC_URI="http://why.lri.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="apron coq doc gappa gtk pff pvs"

RDEPEND="apron? ( sci-mathematics/apron )
	coq? ( sci-mathematics/coq )
	gappa? ( sci-mathematics/gappalib-coq )
	pff? ( sci-mathematics/pff )
	pvs? ( sci-mathematics/pvs )"

DEPEND="${RDEPEND}
	>=dev-lang/ocaml-3.09
	gtk? ( >=dev-ml/lablgtk-2.6 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	
	sed -i Makefile.in \
		-e "s/\$(COQLIB)/\$(DESTDIR)\/\$(COQLIB)/g" \
		-e "s/-w \$(DESTDIR)\/\$(COQLIB)/-w \$(COQLIB)/g" \
		-e "s/\$(PVSLIB)\/why/\$(DESTDIR)\$(PVSLIB)\/why/g"
}

src_compile(){
	econf $(use_enable apron) || die "econf failed"
	#Makfile need a fix to enable parallel building
	emake -j1 DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc CHANGES COPYING README Version
	doman doc/why.1

	if use doc; then
		dodoc doc/manual.ps
	fi
}

