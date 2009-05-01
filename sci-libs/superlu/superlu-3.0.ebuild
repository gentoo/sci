# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MY_PN=SuperLU

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="http://crd.lbl.gov/~xiaoye/SuperLU/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples test"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MY_PN}_${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${PN}-examples.patch
	epatch "${FILESDIR}"/${PN}-makeinc.patch
	eautoreconf
}

src_compile() {
	econf \
		--with-blas="$(pkg-config --libs blas)" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_test() {
	cd TESTING/MATGEN
	emake || die "emake matrix generation failed"
	cd ..
	emake \
		SUPERLULIB=SRC/.libs/libsuperlu.a \
		BLASLIB="$(pkg-config --libs blas)" \
		|| die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
	use doc && newdoc INSTALL/ug.ps userguide.ps
	if use examples; then
		insinto /usr/share/doc/${PF}
		newins -r EXAMPLE examples
	fi
}
