# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="Calculates maximally localized Wannier functions (MLWFs)"
HOMEPAGE="http://www.wannier.org/"
SRC_URI="https://github.com/wannier-developers/wannier90/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples perl static-libs"

RDEPEND="
	virtual/blas
	virtual/lapack
	virtual/mpi
	perl? ( dev-lang/perl )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	cp config/make.inc.gfort make.inc || die
}

src_configure() {
	cat <<- EOF >> "${S}"/make.sys
		F90 = $(tc-getFC)
		FCOPTS = ${FCFLAGS:- ${FFLAGS:- -O2}}
		LDOPTS = ${LDFLAGS}
		LIBS = $($(tc-getPKG_CONFIG) --libs blas lapack)
	EOF
}

src_test() {
	einfo "Compare the 'Standard' and 'Current' outputs of this test."
	cd test-suite || die
	./run_tests --default || die
}

src_install() {
	dobin wannier90.x
	use perl && dobin utility/kmesh.pl
	use static-libs && dolib.a libwannier.a
	doheader src/obj/*.mod
	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
