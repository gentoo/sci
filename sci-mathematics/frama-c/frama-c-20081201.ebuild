# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit autotools eutils

DESCRIPTION="Frama-C is a suite of tools dedicated to the analysis of the source code of software written in C."
HOMEPAGE="http://www.frama-c.cea.fr/"
SRC_URI="http://www.frama-c.cea.fr/download/${PN/-c/-c-Lithium}-${PV/_/+}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="apron coq doc gappa gtk pff pvs"
RESTRICT="strip"

RDEPEND="!sci-mathematics/why
		sci-mathematics/ltl2ba
		apron? ( sci-mathematics/apron )
        coq? ( sci-mathematics/coq )
        gappa? ( sci-mathematics/gappalib-coq )
        pff? ( sci-mathematics/pff )
        pvs? ( sci-mathematics/pvs )"

DEPEND="${RDEPEND}
		>=dev-lang/ocaml-3.09
		gtk? ( >=dev-ml/lablgtk-2.6 )"

S="${WORKDIR}/${PN/-c/-c-Lithium}-${PV/_/+}"

src_unpack(){
	unpack ${A}
	cd "${S}"

	sed -i why/Makefile.in \
		-e "s/\$(COQLIB)/\$(DESTDIR)\/\$(COQLIB)/g" \
		-e "s/-w \$(DESTDIR)\/\$(COQLIB)/-w \$(COQLIB)/g" \
		-e "s/\$(PVSLIB)\/why/\$(DESTDIR)\/\$(PVSLIB)\/why/g" \
		-e "s/\$(MIZFILES)/\$(DESTDIR)\/\$(MIZFILES)/g" \
		-e "s/@MIZARLIB@/\$(DESTDIR)\/@MIZARLIB@/g"

	sed -i configure.in -e "s/--mandir=\$mandir --enable-apron=\$HAS_APRON/ \
		--mandir=\$mandir --host=\$host --build=\$build --enable-apron=\$HAS_APRON/g"
	eautoreconf
}

src_compile() {
	if use gtk; then
		myconf="--enable-gui"
	else
		myconf="--disable-gui"
	fi

	econf ${myconf} || die "econf failed"
	#Makfile need a fix to enable parallel building for the 'depend' rule
	emake -j1 depend || die "emake depend failed"
	emake all top DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc Changelog doc/README
	for i in why/CHANGES why/COPYING why/README why/Version;
		do mv $i $i.why; done
	dodoc why/CHANGES.why why/COPYING.why why/README.why why/Version.why
	doman why/doc/why.1

	if use doc; then
		mv why/doc/manual.ps why/doc/why-manual.ps
		dodoc doc/manuals/* why/doc/why-manual.ps
	fi
}

