# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs autotools

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="app-admin/eselect-cblas"
DEPEND="${RDEPEND}"

pkg_setup() {
	# icc-10.0.025 did not pass some tests
	if [[ $(tc-getCC) == icc ]]; then
		eerror "icc known to fail tests. Revert to safer gcc and re-emerge."
		die "gsl does not work when compiled with icc"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix for as-needed
	epatch "${FILESDIR}"/gsl-1.6-deps.diff
	eautoreconf
}

src_compile() {
	replace-cpu-flags k6 k6-2 k6-3 i586
	filter-flags -ffast-math

	econf || die "econf failed"
	emake || die 'emake failed.'
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog NEWS README SUPPORT THANKS TODO

	# take care of pkgconfig file for cblas implementation.
	cp "${FILESDIR}"/cblas.pc.in cblas.pc
	sed -i \
		-e "s/@LIBDIR@/$(get_libdir)/" \
		-e "s/@PV@/${PV}/" \
		cblas.pc || die "sed cblas.pc failed"
	insinto /usr/$(get_libdir)/blas/gsl
	doins cblas.pc
	eselect cblas add $(get_libdir) "${FILESDIR}"/eselect.cblas.gsl gsl
}

pkg_postinst() {
	[[ -z "$(eselect cblas show)" ]] && eselect cblas set gsl
	elog "To use CBLAS gsl implementation, you have to issue (as root):"
	elog "\t eselect cblas set gsl"
}
