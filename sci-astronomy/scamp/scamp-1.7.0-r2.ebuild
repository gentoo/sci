# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils multilib

DESCRIPTION="Astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://www.astromatic.net/software/scamp"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc threads plplot"

RDEPEND=">=sci-astronomy/cdsclient-3.4
	sci-libs/atlas[lapack,threads=]
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	local mycblas=atlcblas  myclapack=atlclapack
	if use threads; then
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptcblas.so ]] && \
			mycblas=ptcblas
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptclapack.so ]] &&
		myclapack=ptclapack
	fi
	# fix the configure and not the acx_atlas.m4. the eautoreconf will
	# produce a configure giving  a wrong install Makefile target (to fix)
	sed -i \
		-e "s/-lcblas/-l${mycblas}/g" \
		-e "s/AC_CHECK_LIB(cblas/AC_CHECK_LIB(${mycblas}/g" \
		-e "s/-llapack/-l${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		 acx_atlas.m4 || die
	epatch "${FILESDIR}"/${P}-plplot599.patch
	sed -i -e 's/doc//' Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas"
		$(use_with plplot)
		$(use_enable threads)
	)
	autotools-utils_src_configure
}

src_install () {
	autotools-utils_src_install
	use doc && dodoc doc/*
}
