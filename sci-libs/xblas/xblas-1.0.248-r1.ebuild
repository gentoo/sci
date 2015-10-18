# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBASE_PROFNAME="xblas"
inherit eutils flag-o-matic fortran-2 fortran-int64 multibuild multilib multilib-build toolchain-funcs versionator

DESCRIPTION="Extra Precise Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.netlib.org/xblas"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran int64 static-libs"

RDEPEND="fortran? ( virtual/fortran )"
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
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	multibuild_copy_sources
}

src_configure() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_configure() {
		export FCFLAGS="${FCFLAGS} $(get_abi_CFLAGS) $(fortran-int64_get_fortran_int64_abi_fflags)"
		econf $(use_enable fortran)
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_compile() {
		local profname=$(fortran-int64_get_profname)
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
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_compile
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_test () {
		emake tests
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_install() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		dolib.so lib${libname}$(get_libname)*
		use static-libs && newlib.a lib${libname}_nonpic.a lib${libname}.a
		dodoc README README.devel
		use doc && dodoc doc/report.ps

		# pkg-config file for our multliple numeric stuff
		cat > ${profname}.pc <<-EOF
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include/${PN}
			Name: ${profname}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -l${libname}
			Cflags: -I\${includedir}
			Fflags=$(fortran-int64_get_fortran_int64_abi_fflags)
		EOF
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${profname}.pc
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_install
}
