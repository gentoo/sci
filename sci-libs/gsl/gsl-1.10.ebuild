# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gsl/gsl-1.9-r1.ebuild,v 1.1 2007/08/21 17:53:34 bicatali Exp $

inherit eutils flag-o-matic toolchain-funcs autotools

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64  ~sparc ~x86 ~x86-fbsd"
IUSE="cblas"

DEPEND="app-admin/eselect-cblas
	dev-util/pkgconfig
	cblas? ( virtual/cblas )"

RDEPEND="app-admin/eselect-cblas
	cblas? ( virtual/cblas )"


pkg_setup() {
	# icc-10.0.026 did not pass rng tests (last check: gsl-1.10)
	if [[ $(tc-getCC) == icc ]]; then
		eerror "icc known to fail tests. Revert to safer gcc and re-emerge."
		die "gsl does not work when compiled with icc"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gsl-cblas.patch
	eautoreconf
}

src_compile() {
	# could someone check if they are still needed?
	replace-cpu-flags k6 k6-2 k6-3 i586
	filter-flags -ffast-math
	local myconf=
	use cblas && myconf="--with-cblas=$(pkg-config --libs cblas)"
	econf "${myconf}"|| die "econf failed"
	emake || die 'emake failed.'
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog NEWS README SUPPORT \
		THANKS TODO || die "dodoc failed"

	# take care of pkgconfig file for cblas implementation.
	sed -e "s/@LIBDIR@/$(get_libdir)/" \
		-e "s/@PV@/${PV}/" \
		"${FILESDIR}"/cblas.pc.in > cblas.pc \
		|| die "sed cblas.pc failed"
	insinto /usr/$(get_libdir)/blas/gsl
	doins cblas.pc || die "installing cblas.pc failed"
	eselect cblas add $(get_libdir) "${FILESDIR}"/eselect.cblas.gsl gsl
}

pkg_postinst() {
	[[ -z "$(eselect cblas show)" ]] && eselect cblas set gsl
	elog "To use CBLAS gsl implementation, you have to issue (as root):"
	elog "\t eselect cblas set gsl"
}
