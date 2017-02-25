# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="OCaml interface to the GMP and MPFR libraries"
HOMEPAGE="http://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/"
SRC_URI="https://gforge.inria.fr/frs/download.php/20228/${PN}-${PV}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +mpfr"

RDEPEND="
	>=dev-lang/ocaml-3.09
	dev-ml/camlidl
	dev-libs/gmp:0
	mpfr? ( dev-libs/mpfr:0 )"
DEPEND="${RDEPEND}
	doc? (
		app-text/texlive
		app-text/ghostscript-gpl
		)"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -R html mlgmpidl.pdf || die
	mv Makefile.config.model Makefile.config || die
	sed \
		-e "s/FLAGS = \\\/FLAGS += \\\/g" \
		-e "s/-O3 -UNDEBUG/-DUDEBUG/g" \
		-e "s/MLGMPIDL_PREFIX = /MLGMPIDL_PREFIX = \$(DESTDIR)\/usr/g" \
		-i Makefile.config || die

	if use !mpfr; then
		sed -i -e "s/HAS_MPFR=1/#HAS_MPFR=0/g" Makefile.config || die
	fi

	epatch "${FILESDIR}"/${P}-mpfr-3_compat.patch
}

src_compile() {
	emake -j1 all gmprun gmptop

	use doc && emake html mlgmpidl.pdf
}

src_install(){
	use doc && DOCS+=( mlgmpidl.pdf )
	default
}
