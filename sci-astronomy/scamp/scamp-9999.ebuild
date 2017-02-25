# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit subversion autotools

ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
ESVN_OPTIONS="--trust-server-cert-failures=unknown-ca"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://www.astromatic.net/software/scamp"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc plplot threads"

RDEPEND="
	net-misc/curl:=
	sci-libs/atlas[lapack,threads=]
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	local mycblas=atlcblas myclapack=atlclapack
	if use threads; then
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptcblas.so ]] && \
			mycblas=ptcblas
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptclapack.so ]] && \
			myclapack=ptclapack
	fi
	sed -e "s/-lcblas/-l${mycblas}/g"\
		-e "/SEARCH_LIBS/s/ cblas,/${mycblas},/g" \
		-e "/SEARCH_LIBS/s/lapack_atlas/${myclapack}/g" \
		-i acx_atlas.m4 || die
	eautoreconf
	subversion_src_prepare
}

src_configure() {
	econf \
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas" \
		$(use_enable plplot) \
		$(use_enable threads)
}

src_install () {
	default
	use doc && dodoc doc/*
}
