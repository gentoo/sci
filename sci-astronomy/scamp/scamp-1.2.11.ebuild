# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Computes astrometric and photometric solutions for astronomical images."
HOMEPAGE="http://terapix.iap.fr/soft/scamp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz
	doc? http://terapix.iap.fr/IMG/pdf/${PN}.pdf"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc threads icc plplot"
# I think this works only with ATLAS lapack implementation.
DEPEND="sci-astronomy/cdsclient
	sci-libs/blas-atlas
	sci-libs/lapack-atlas
	app-admin/eselect-blas
	app-admin/eselect-cblas
	app-admin/eselect-lapack
	>=sci-libs/fftw-3
	plplot? ( >=sci-libs/plplot-5.1 )
	icc? ( dev-lang/icc )"

pkg_setup() {
	if use threads; then
		if ! built_with_use sci-libs/fftw threads; then
			ewarn "when use threads, fftw must be compiled with threads as well"
			die
		fi
	fi

	if ! eselect blas show | grep -q atlas; then
		ewarn "You must have atlas selected for blas: run"
		ewarn "$ eselect blas set atlas"
		die
	fi
	if ! eselect cblas show | grep -q atlas; then
		ewarn "You must have atlas selected for cblas: run"
		ewarn "$ eselect cblas set atlas"
		die
	fi
	if ! eselect lapack show | grep -q atlas; then
		ewarn "You must have atlas selected for lapack: run"
		ewarn "$ eselect lapack set atlas"
		die
	fi
}

src_compile() {
	# trust swarp cflags to be optimized.
	filter-flags ${CFLAGS}
	# --disable-threads does not compile
	local myconf=""
	use threads && myconf="--enable-threads "
	econf \
		$(use_enable static) \
		$(use_enable icc) \
		$(use_with plplot) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins ${DISTDIR}/${PN}.pdf
	fi
}
