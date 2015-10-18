# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	_SVN=subversion
	ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit ${_SVN} autotools-utils multilib

DESCRIPTION="Astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://www.astromatic.net/software/scamp"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc plplot threads"

RDEPEND="
	>=sci-astronomy/cdsclient-3.4
	sci-libs/atlas[lapack,threads=]
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	local mycblas=atlcblas myclapack=atlclapack
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
		-e "s/\(lapack_lib=\).*/\1${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		acx_atlas.m4 || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas"
		$(use_enable plplot)
		$(use_enable threads)
	)
	autotools-utils_src_configure
}

src_install () {
	autotools-utils_src_install
	use doc && dodoc doc/*
}
