# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Computes astrometric and photometric solutions for astronomical images."
HOMEPAGE="http://terapix.iap.fr/soft/scamp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz
	doc? http://terapix.iap.fr/IMG/pdf/${PN}.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc icc threads plplot"

# I think this works only with ATLAS lapack implementation.
RDEPEND="sci-astronomy/cdsclient
	sci-libs/blas-atlas
	sci-libs/lapack-atlas
	>=sci-libs/fftw-3
	plplot? ( >=sci-libs/plplot-5.1 )"
DEPEND="${RDEPEND}
	app-admin/eselect-blas
	app-admin/eselect-cblas
	app-admin/eselect-lapack
	icc? ( dev-lang/icc )"

pkg_setup() {
	if ! eselect blas show | grep -q atlas; then
		ewarn "You must have atlas selected for blas: try"
		ewarn "$ eselect blas set atlas"
		die
	fi
	if ! eselect cblas show | grep -q atlas; then
		ewarn "You must have atlas selected for cblas: try"
		ewarn "$ eselect cblas set atlas"
		die
	fi
	if ! eselect lapack show | grep -q atlas; then
		ewarn "You must have atlas selected for lapack: try"
		ewarn "$ eselect lapack set atlas"
		die
	fi
	if use threads && ! eselect lapack show | grep -q atlas; then
		ewarn "scamp threaded only works with blas threaded."
		ewarn "You must have threaded-atlas selected for blas: try"
		ewarn "$ eselect blas set threaded-atlas"
		die
	fi
}

src_compile() {
	local myconf
	# --disable-threads is buggy
	use threads && myconf="--enable-threads"
	econf \
		$(use_enable static) \
		$(use_enable icc) \
		$(use_with plplot) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins ${DISTDIR}/${PN}.pdf
	fi
}
