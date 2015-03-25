# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Library for static analysis of the numerical variables of a program by Abstract Interpretation"
HOMEPAGE="http://apron.cri.ensmp.fr/library/"
SRC_URI="http://apron.cri.ensmp.fr/library/${P}.tgz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cxx doc ocaml ppl"

RDEPEND="ocaml? ( >=dev-lang/ocaml-3.09
				dev-ml/camlidl
				dev-ml/mlgmpidl )
		dev-libs/gmp
		dev-libs/mpfr
		ppl? ( dev-libs/ppl )"
DEPEND="${RDEPEND}
		doc? ( app-text/texlive
				app-text/ghostscript-gpl
				cxx? ( app-doc/doxygen
						dev-tex/rubber ) )"

src_prepare() {
	mv Makefile.config.model Makefile.config

	#fix compile process
	sed -i Makefile.config \
		-e "s/FLAGS = \\\/FLAGS += \\\/g" \
		-e "s/-O3 -DNDEBUG/-DNDEBUG/g" \
		-e "s/APRON_PREFIX =.*/APRON_PREFIX = \$(DESTDIR)\/usr/g" \
		-e "s/MLGMPIDL_PREFIX =.*/MLGMPIDL_PREFIX = \$(DESTDIR)\/usr/g"

	#fix doc building process
	sed -i Makefile -e "s/; make html/; make/g"
	sed -i apronxx/Makefile \
		-e "s:cd doc/latex && make:cd doc/latex; rubber refman.tex; dvipdf refman.dvi:g"
	sed -i apronxx/doc/Doxyfile \
		-e "s/OUTPUT_DIRECTORY       = \/.*/OUTPUT_DIRECTORY       = .\//g" \
		-e "s/STRIP_FROM_PATH        = \/.*/STRIP_FROM_PATH        = .\//g"

	#fix ppl install for 32 platforms
	sed -i ppl/Makefile -e "s/libap_ppl_caml\*\./libap_ppl\*\./g"

	if [[ "$(gcc-major-version)" == "4" ]]; then
		sed -i -e "s/# HAS_LONG_DOUBLE = 1/HAS_LONG_DOUBLE = 1/g" Makefile.config
	fi
	if use !ocaml; then
		sed -i -e "s/HAS_OCAML = 1/#HAS_OCAML = 0/g" Makefile.config
	fi
	if use ppl; then
		sed -i -e "s/# HAS_PPL = 1/HAS_PPL = 1/g" Makefile.config
	fi
	if use cxx; then
		if use ppl; then
			sed -i -e "s/# HAS_CPP = 1/HAS_CPP = 1/g" Makefile.config
		else
			die "USE flag 'cxx' needs USE flag 'ppl' set"
		fi
	fi
}

src_compile() {
	#damn crappy Makefile
	emake || emake || die "emake failed"

	if use doc && use cxx; then
		emake -C apronxx doc || "emake doc failed"
	fi
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS Changes README

	if use doc; then
		dodoc apron/apron.pdf
		if use ocaml; then
			dodoc mlapronidl/mlapronidl.pdf
		fi
		if use cxx; then
			mv apronxx/doc/latex/refman.pdf apronxx/apronxx.pdf
			dodoc ./apronxx/apronxx.pdf
		fi
	fi
}
