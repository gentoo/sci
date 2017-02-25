# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NUMERIC_MODULE_NAME="xblas"
FORTRAN_NEEDED=fortran

inherit flag-o-matic fortran-2 numeric-int64-multibuild toolchain-funcs versionator

DESCRIPTION="Extra Precise Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.netlib.org/xblas"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/m4"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version)) || die
		ln -s ${soname} ${libdir}/${libname}$(get_libname) || die
	fi
}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	numeric-int64-multibuild_copy_sources
}

src_configure() {
	xblas_configure() {
		export FCFLAGS="${FCFLAGS} $(get_abi_CFLAGS) $(numeric-int64_get_fortran_int64_abi_fflags)"
		econf $(use_enable fortran)
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir xblas_configure
}

src_compile() {
	xblas_src_compile() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		# default target builds and runs tests - split
		# build first static libs because of fPIC afterwards
		# and we link tests with shared ones
		if use static-libs; then
			emake makefiles
			emake lib XBLASLIB=lib${libname}_nonpic.a
			emake clean
		fi
		sed -i \
			-e 's:\(CFLAGS.*\).*:\1 -fPIC:' \
			make.inc || die
		emake makefiles
		emake lib XBLASLIB=lib${libname}.a
		static_to_shared lib${libname}.a
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir xblas_src_compile
}

src_test() {
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir emake tests
}

src_install() {
	xblas_src_install() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		if numeric-int64_is_static_build; then
			use static-libs && newlib.a lib${libname}_nonpic.a lib${libname}.a
		else
			dolib.so lib${libname}$(get_libname)*

			create_pkgconfig \
				--name  ${profname} \
				--libs "-L\${libdir} -l${libname}" \
				--cflags "-I\${includedir} $(numeric-int64_get_fortran_int64_abi_fflags)" \
				${profname}
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir xblas_src_install

	dodoc README README.devel
	use doc && dodoc doc/report.ps
}
