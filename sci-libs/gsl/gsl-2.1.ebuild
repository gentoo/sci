# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NUMERIC_MODULE_NAME="gsl"

inherit autotools flag-o-matic numeric-int64-multibuild toolchain-funcs

DESCRIPTION="GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/19"
KEYWORDS="~amd64 ~mips ~s390 ~sh ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( >=virtual/cblas-2.0-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-cblas-external.patch )

src_prepare() {
	default
	eautoreconf
	numeric-int64-multibuild_copy_sources
}

src_configure() {
	gsl_configure() {
		if use cblas-external; then
			export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
			export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
		fi
		if numeric-int64_is_int64_build; then
			append-fflags $(fortran_int64_abi_fflags)
		fi
		econf $(use_with cblas-external)
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir gsl_configure
}

src_compile() {
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir default
}

src_test() {
	local MAKEOPTS="${MAKEOPTS} -j1"
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir default
}

src_install() {
	gsl_src_install() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"

		default

		if ! numeric-int64_is_static_build; then
			create_pkgconfig \
				--name  ${profname} \
				--description "${DESCRIPTION} CBLAS implementation" \
				--libs "-L\${libdir} -l${libname}" \
				--libs-private "-lm" \
				--cflags "-I\${includedir} $(numeric-int64_get_fortran_int64_abi_fflags)" \
				${profname}
		fi

	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir gsl_src_install

	printf "/usr/include/cblas.h ${PN}/cblas.h" > "${T}"/alternative-cblas-generic.sh || die

	use cblas-external || \
		numeric-int64-multibuild_install_alternative cblas ${NUMERIC_MODULE_NAME}
}
