# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils toolchain-funcs

MY_PN=SuperLU

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${PN}-examples.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-blas="$(pkg-config --libs blas)"
}

src_test() {
	cd TESTING/MATGEN
	emake \
		FORTRAN="$(tc-getFC)" \
		LOADER="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LOADOPTS="${LDFLAGS}" \
		SUPERLULIB="../SRC/.libs/libsuperlu.a" \
		BLASLIB="$(pkg-config --libs blas)" \
		CC="$(tc-getCC)" \
		|| die "emake matrix generation failed"
	cd ..
	emake \
		CC="$(tc-getCC)" \
		FORTRAN="$(tc-getFC)" \
		LOADER="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LOADOPTS="${LDFLAGS}" \
		SUPERLULIB="../SRC/.libs/libsuperlu.so" \
		BLASLIB="$(pkg-config --libs blas)" \
		|| die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/include/${PN}
	doins SRC/*.h || die

	dodoc README
	use doc && newdoc INSTALL/ug.ps userguide.ps
	if use examples; then
		insinto /usr/share/doc/${PF}
		newins -r EXAMPLE examples
	fi
}
