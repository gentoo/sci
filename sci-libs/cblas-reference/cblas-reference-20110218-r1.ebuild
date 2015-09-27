# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBASE_PROFNAME="refcblas"
inherit eutils alternatives-2 flag-o-matic toolchain-funcs versionator multilib fortran-2 multilib-build fortran-int64

MYPN="${PN/-reference/}"

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/blast-forum/${MYPN}.tgz -> ${P}.tgz"

SLOT="0"
LICENSE="public-domain"
IUSE="int64 static-libs"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND=">=virtual/cblas-2.0-r2[int64?]"

S="${WORKDIR}/CBLAS"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cblas/cblas.h
)

static_to_shared() {
	local libstatic=$1
	shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/$(get_libdir)/${soname} \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		if [[ $(get_version_component_count) -gt 1 ]]; then
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version)) || die
		fi
	fi
	ln -s ${soname} ${libdir}/${libname}$(get_libname) || die
}

src_prepare() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	fortran-int64_ensure_blas
	find . -name Makefile -exec sed -i \
		-e 's:make:$(MAKE):g' '{}' \; || die
	multibuild_copy_sources
}

src_configure() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_configure() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		append-cflags -DADD_
		cat > Makefile.in <<-EOF
			BLLIB=$($(tc-getPKG_CONFIG) --libs $(fortran-int64_get_blas_provider))
			FC=$(tc-getFC) $(get_abi_CFLAGS) $(fortran-int64_get_fortran_int64_abi_fflags)
			CC=$(tc-getCC)
			CBLIB=../lib/lib${libname}.a
			LOADER=\$(FC)
			ARCH=$(tc-getAR)
			ARCHFLAGS=cr
			RANLIB=$(tc-getRANLIB)
		EOF
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_compile() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		emake \
			FFLAGS="${FFLAGS} -fPIC" \
			CFLAGS="${CFLAGS} -fPIC" \
			alllib
		static_to_shared lib/lib${libname}.a $($(tc-getPKG_CONFIG) --libs $(fortran-int64_get_blas_profname))
		if use static-libs; then
			emake clean
			emake alllib
		fi
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_compile
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_test () {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		cd testing || die
		default
		emake run
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_install() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		local provider=$(fortran-int64_get_cblas_provider)
		# On linux dynamic libraries are of the form .so.${someversion}
		# On  OS X dynamic libraries are of the form ${someversion}.dylib
		dolib.so lib/lib${libname}*$(get_libname)*
		use static-libs && dolib.a lib/lib${libname}.a
		insinto /usr/include/cblas
		doins include/cblas.h
		cat <<-EOF > ${profname}.pc
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ${profname}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -l${libname}
			Private: -lm
			Cflags: -I\${includedir}/cblas
			Requires: $(fortran-int64_get_blas_profname)
			Fflags=$(fortran-int64_get_fortran_int64_abi_fflags)
		EOF
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${profname}.pc
		alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
			/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc \
			/usr/include/cblas.h cblas/cblas.h
		if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
			multilib_prepare_wrappers
			multilib_check_headers
		fi
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_install
	multilib_install_wrappers

	dodoc README
	insinto /usr/share/doc/${PF}
	doins examples/*.c
}
