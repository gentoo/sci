# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="MLGMPIDL is an OCaml interface to the GMP and MPFR libraries"
HOMEPAGE="http://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/"
SRC_URI="https://gforge.inria.fr/frs/download.php/20228/${PN}-${PV}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc +mpfr"

DEPEND=">=dev-lang/ocaml-3.09
		dev-ml/camlidl
		dev-libs/gmp
		mpfr? ( dev-libs/mpfr )
		doc? ( app-text/texlive
				app-text/ghostscript-gpl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -R html mlgmpidl.pdf
	mv Makefile.config.model Makefile.config
	sed -i Makefile.config \
		-e "s/FLAGS = \\\/FLAGS += \\\/g" \
		-e "s/-O3 -UNDEBUG/-DUDEBUG/g" \
		-e "s/MLGMPIDL_PREFIX = /MLGMPIDL_PREFIX = \${DESTDIR}\/usr/g"

	if use !mpfr; then
		sed -i -e "s/HAS_MPFR=1/#HAS_MPFR=0/g" Makefile.config
	fi

	epatch "${FILESDIR}/${P}-mpfr-3_compat.patch"
}

src_compile() {
	emake all gmprun gmptop -j1 || die "emake failed"

	if use doc; then
		make html mlgmpidl.pdf || die "emake doc failed"
	fi
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README

	if use doc; then
		dodoc mlgmpidl.pdf
	fi
}
