# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Computes astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://terapix.iap.fr/soft/scamp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc threads plplot"
RESTRICT="test"

# right now just work with ATLAS implementations
# need more work on virtual/cblas eselect for more blas/lapack impl.
RDEPEND="sci-astronomy/cdsclient
	>=sci-libs/blas-atlas-3.7.11-r1
	>=sci-libs/lapack-atlas-3.7.11-r1
	>=sci-libs/fftw-3
	plplot? ( >=sci-libs/plplot-5.1 )"
DEPEND="${RDEPEND}
	app-admin/eselect-cblas
	app-admin/eselect-lapack"

pkg_setup() {

	if ! eselect cblas show | grep -q atlas; then
		ewarn "You must have atlas selected for cblas: try"
		ewarn "$ eselect cblas set atlas  # or threaded-atlas"
		die
	fi

	if ! eselect lapack show | grep -q atlas; then
		ewarn "You must have atlas selected for lapack: try"
		ewarn "$ eselect lapack set atlas"
		die
	fi

	if use threads && ! eselect cblas show | grep -q threaded; then
		ewarn "scamp with threads only works with threaded-atlas"
		ewarn "You must have threaded-atlas selected for cblas: try"
		ewarn "$ eselect cblas set threaded-atlas"
		die
	fi

}
src_unpack() {
	unpack ${A}
	cd "${S}"
	# get gentoo threaded blas library name right
	sed -i \
		-e 's/ptcblas/cblas/g' \
		configure || die "sed failed"
}

src_compile() {

	local myconf
	[[ "$(tc-getCC)" == "icc" ]] \
		&& myconf="${myconf} --enable-icc"

	econf \
		$(use_with plplot) \
		$(use_enable threads) \
		"${myconf}" \
		LDPATH=-L/usr/$(get_libdir)/lapack/atlas \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/${PN}.pdf
	fi
}
