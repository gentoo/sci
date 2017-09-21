# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit alternatives-2 autotools-multilib eutils toolchain-funcs

DESCRIPTION="GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( >=virtual/cblas-2.0-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-cblas-external.patch )

src_configure() {
	if use cblas-external; then
		export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
		export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
	fi
	local myeconfargs=(
		$(use_with cblas-external)
	)
	autotools-multilib_src_configure
}

multilib_src_install() {
	autotools-utils_src_install
	local libname=gslcblas

	cat <<-EOF > ${libname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${libname}
		Description: ${DESCRIPTION} CBLAS implementation
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${libname}
		Libs.private: -lm
		Cflags: -I\${includedir}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${libname}.pc

	GSL_ALTERNATIVES+=( /usr/$(get_libdir)/pkgconfig/cblas.pc ${libname}.pc )
}

multilib_src_install_all() {
	# Don't add gsl as a cblas alternative if using cblas-external
	use cblas-external || alternatives_for cblas gsl 0 \
		${GSL_ALTERNATIVES[@]} \
		/usr/include/cblas.h gsl/gsl_cblas.h
}
