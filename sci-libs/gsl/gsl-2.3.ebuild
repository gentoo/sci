# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit alternatives-2 autotools multilib-build numeric toolchain-funcs

DESCRIPTION="GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/19"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( >=virtual/cblas-2.0-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-cblas-external.patch
	)

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

src_configure() {
	gsl_configure() {
		if use cblas-external; then
			export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
			export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
		fi
		econf $(use_with cblas-external)
	}
	multilib_foreach_abi run_in_build_dir gsl_configure
}

src_compile() {
	multilib_foreach_abi run_in_build_dir default
}

src_test() {
	multilib_foreach_abi run_in_build_dir default
}

src_install() {
	gsl_install() {
		local libname=gslcblas

		create_pkgconfig \
				--name  "${libname}" \
				--description "${PN} CBLAS implementation" \
				--libs "-l${libname}" \
				--libs-private "-lm" \
				--cflags "-I\${includedir}/${PN}" \
				--version "${PV}" \
				--url "${HOMEPAGE}" \
				"${libname}"

		GSL_ALTERNATIVES+=( /usr/$(get_libdir)/pkgconfig/cblas.pc ${libname}.pc )

		default
	}
	multilib_foreach_abi run_in_build_dir gsl_install

	# Don't add gsl as a cblas alternative if using cblas-external
	use cblas-external || alternatives_for cblas gsl 0 \
		${GSL_ALTERNATIVES[@]} \
		/usr/include/cblas.h gsl/gsl_cblas.h
}
