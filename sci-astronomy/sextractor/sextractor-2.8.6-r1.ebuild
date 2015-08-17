# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DESCRIPTION="Extract catalogs of sources from astronomical FITS images"
HOMEPAGE="http://www.astromatic.net/software/sextractor"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc threads"

RDEPEND="
	sci-libs/atlas[lapack]
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-configure.patch
	local mycblas=atlcblas  myclapack=atlclapack
	if use threads; then
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptcblas.so ]] && \
			mycblas=ptcblas
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptclapack.so ]] && \
			myclapack=ptclapack
	fi
	sed -i \
		-e "s/-lcblas/-l${mycblas}/g" \
		-e "s/AC_CHECK_LIB(cblas/AC_CHECK_LIB(${mycblas}/g" \
		-e "s/-llapack/-l${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		acx_atlas.m4 || die "sed acx_atlas.m4 failed"
	eautoreconf
}

src_configure() {
	econf \
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas" \
		$(use_enable threads)
}

src_install () {
	default
	CONFDIR=/usr/share/sextractor
	insinto ${CONFDIR}
	doins config/*
	use doc && dodoc doc/*
}

pkg_postinst() {
	elog "SExtractor examples configuration files are located in"
	elog "${EROOT}/${CONFDIR} and are not loaded anymore by default."
}
