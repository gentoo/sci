# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils toolchain-funcs

DESCRIPTION="The APRON library is dedicated to the static analysis of the numerical variables of a program by Abstract Interpretation"
HOMEPAGE="http://apron.cri.ensmp.fr/library/"
SRC_URI="http://apron.cri.ensmp.fr/library/${P}.tgz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cxx doc ocaml ppl"

RDEPEND="dev-libs/gmp
		dev-libs/mpfr
		ocaml? ( >=dev-lang/ocaml-3.09
				dev-ml/camlidl )
		ppl? ( dev-libs/ppl )"
DEPEND="${RDEPEND}
		doc? ( app-text/texlive
				app-text/ghostscript-gpl 
				cxx? ( app-doc/doxygen ) )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-ppl.patch"
	epatch "${FILESDIR}/${P}-doc.patch"

	mv Makefile.config.model Makefile.config
	sed -i Makefile.config \
		-e "s/FLAGS = \\\/FLAGS += \\\/g" \
		-e "s/-O3 -DNDEBUG/-DNDEBUG/g" \
		-e "s/APRON_PREFIX = \/usr/APRON_PREFIX = \${DESTDIR}\/usr/g" \
		-e "s/MLGMPIDL_PREFIX = \/usr\/local/MLGMPIDL_PREFIX = \${DESTDIR}\/usr/g"
	sed -i apronxx/doc/Doxyfile \
		-e "s/OUTPUT_DIRECTORY       = \/.*/OUTPUT_DIRECTORY       = .\//g" \
		-e "s/STRIP_FROM_PATH        = \/.*/STRIP_FROM_PATH        = .\//g"

	if use doc; then
		#we just create the pdf manuals
		sed -i Makefile -e "s/; make html/; make/g"
	fi

	if [[ "$(gcc-major-version)" == "4" ]]; then
		sed -i -e "s/# HAS_LONG_DOUBLE = 1/HAS_LONG_DOUBLE = 1/g" Makefile.config
	fi
	if use !ocaml; then
		sed -i -e "s/HAS_OCAML = 1/HAS_OCAML = 0/g" Makefile.config
	fi
	if use ppl; then
		sed -i -e "s/# HAS_PPL = 1/HAS_PPL = 1/g" Makefile.config
	fi
	if use cxx && use ppl; then
		sed -i -e "s/# HAS_CPP = 1/HAS_CPP = 1/g" Makefile.config
	else
		die "USE flag 'cxx' needs USE flag 'ppl' set"
	fi
}

src_compile() {
	emake || emake #dirty hack because of a crappy makefile
	emake || die "emake failed"

	if use doc; then
		emake doc || "emake doc failed"
	fi
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS Changes COPYING README

	if use doc; then
		dodoc ./apron/apron.pdf
		if use ocaml; then
			dodoc ./mlgmpidl/mlgmpidl.pdf ./mlapronidl/mlapronidl.pdf
		fi
		if use cxx; then
			mv ./apronxx/doc/latex/refman.pdf ./apronxx/apronxx.pdf
			dodoc ./apronxx/apronxx.pdf
		fi
	fi
}

