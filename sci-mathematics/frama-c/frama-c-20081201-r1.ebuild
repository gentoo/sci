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

IUSE="apron coq doc gappa gtk pff pvs stateshook"
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

	if use stateshook; then
		einfo "moving state_set.ml* from value/ to memory_state/ ..."
		mv src/value/state_set.ml* src/memory_state/ || die
		epatch "${FILESDIR}/${P}-states_hook.patch"
		epatch "${FILESDIR}/frama-c-20081201-stmt_deps.patch"
		epatch "${FILESDIR}/frama-c-20081201-accessors.patch"
	fi

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
	
	#Dependencies can not be processed in parallel,
	#this is the intended behavior.
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

	if use stateshook; then
		ewarn "USE flag 'stateshook' is enabled, it is not officially supported so do not report any bug upstream !"
		ewarn "The value analysis does not keep all the several states attached to a statement but just their union."
		ewarn "With this patch you can access all these states through a hook while the analysis is taking place."
	fi
}

