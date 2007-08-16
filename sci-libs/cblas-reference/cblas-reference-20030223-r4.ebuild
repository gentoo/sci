# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils fortran multilib flag-o-matic toolchain-funcs

MyPN="${PN/-reference/}"

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
LICENSE="public-domain"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/blast-forum/${MyPN}.tgz"

SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DEPEND="virtual/blas
	dev-util/pkgconfig
	app-admin/eselect-cblas"

FORTRAN="gfortran g77 ifc"

S="${WORKDIR}/CBLAS"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotool.patch
	eautoreconf
}

src_compile() {
	econf \
		--libdir=/usr/$(get_libdir)/blas/reference \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "failed to install docs"
	insinto /usr/share/doc/${PF}
	doins cblas_example*c
	eselect cblas add $(get_libdir) "${FILESDIR}"/eselect.cblas.reference reference
}

pkg_postinst() {
	[[ -z "$(eselect cblas show)" ]] && eselect cblas set reference
	elog "To use CBLAS reference implementation, you have to issue (as root):"
	elog "\teselect cblas set reference\n"
}
