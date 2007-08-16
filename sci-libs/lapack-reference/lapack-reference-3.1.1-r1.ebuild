# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools flag-o-matic fortran multilib

MyPN="${PN/-reference/}"

DESCRIPTION="FORTRAN reference implementation of LAPACK Linear Algebra PACKage"
LICENSE="BSD"
HOMEPAGE="http://www.netlib.org/lapack/index.html"
SRC_URI="http://www.netlib.org/lapack/${MyPN}-lite-${PV}.tgz"

SLOT="0"
IUSE="doc"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DEPEND="virtual/blas
	app-admin/eselect-lapack"

RDEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/lapack-docs )"

S="${WORKDIR}/${MyPN}-lite-${PV}"

pkg_setup() {
	FORTRAN="g77 gfortran ifc"
	fortran_pkg_setup
	if  [[ ${FORTRANC:0:2} == "if" ]]; then
		ewarn "Using Intel Fortran at your own risk"
		LDFLAGS="$(raw-ldflags)"
		export NOOPT_FFLAGS=-O
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotool.patch
	epatch "${FILESDIR}"/${P}-test-fix.patch
	eautoreconf

	# set up the testing routines
	sed -e "s:g77:${FORTRANC}:" \
		-e "s:-funroll-all-loops -O3:${FFLAGS} $(pkg-config --cflags blas):" \
		-e "s:LOADOPTS =:LOADOPTS = ${LDFLAGS} $(pkg-config --cflags blas):" \
		-e "s:../../blas\$(PLAT).a:$(pkg-config --libs blas):" \
		-e "s:lapack\$(PLAT).a:SRC/.libs/liblapack.a:" \
		make.inc.example > make.inc \
		|| die "Failed to set up make.inc"
}

src_compile() {
	econf \
		--libdir=/usr/$(get_libdir)/lapack/reference \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
	eselect lapack add $(get_libdir) "${FILESDIR}"/eselect.lapack.reference reference
}

src_test() {
	cd TESTING/MATGEN && emake || die "Failed to create tmglib.a"
	cd ../ && emake || die "lapack-reference tests failed."
}

pkg_postinst() {
	[[ -z "$(eselect lapack show)" ]] && eselect lapack set reference
	elog "To use LAPACK reference implementation, you have to issue (as root):"
	elog "\n\teselect lapack set reference\n"
}
