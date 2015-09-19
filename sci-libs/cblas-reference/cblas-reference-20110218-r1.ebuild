# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NUMERIC_MODULE_NAME="refcblas"

inherit alternatives-2 flag-o-matic fortran-2 multilib numeric numeric-int64-multibuild toolchain-funcs versionator

MYPN="${PN/-reference/}"

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/blast-forum/${MYPN}.tgz -> ${P}.tgz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/CBLAS"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cblas/cblas.h
)

static_to_shared() {
	local libstatic=$1
	shift || die
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
	numeric-int64_ensure_blas_int_support
	find . -name Makefile -exec sed -i \
		-e 's:make:$(MAKE):g' '{}' \; || die
	numeric-int64-multibuild_copy_sources
}

src_configure() {
	cblas_configure() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		append-cflags -DADD_
		cat > Makefile.in <<-EOF
			BLLIB=$($(tc-getPKG_CONFIG) --libs $(numeric-int64_get_blas_alternative))
			FC=$(tc-getFC) $(get_abi_CFLAGS) $(numeric-int64_get_fortran_int64_abi_fflags)
			CC=$(tc-getCC)
			CBLIB=../lib/lib${libname}.a
			LOADER=\$(FC)
			ARCH=$(tc-getAR)
			ARCHFLAGS=cr
			RANLIB=$(tc-getRANLIB)
		EOF
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir cblas_configure
}

src_compile() {
	cblas_src_compile() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		emake \
			FFLAGS="${FFLAGS} -fPIC" \
			CFLAGS="${CFLAGS} -fPIC" \
			alllib
		static_to_shared lib/lib${libname}.a $($(tc-getPKG_CONFIG) --libs $(numeric-int64_get_blas_alternative))
		if use static-libs; then
			emake clean
			emake alllib
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir cblas_src_compile
}

src_test() {
	cblas_src_test () {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		cd testing || die
		emake && emake run
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir cblas_src_test
}

src_install() {
	cblas_src_install() {
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		# On linux dynamic libraries are of the form .so.${someversion}
		# On  OS X dynamic libraries are of the form ${someversion}.dylib
		if numeric-int64_is_static_build; then
			dolib.a lib/lib${libname}.a
		else
			dolib.so lib/lib${libname}*$(get_libname)*
			insinto /usr/include/cblas
			doins include/cblas.h
			create_pkgconfig \
				--name "${profname}" \
				--libs "-L\${libdir} -l${libname}" \
				--libs-private "-lm" \
				--cflags "-I\${includedir}/cblas $(numeric-int64_get_fortran_int64_abi_fflags)" \
				--requires $(numeric-int64_get_blas_alternative) \
				${profname}
		fi

		if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
			multilib_prepare_wrappers
			multilib_check_headers
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir cblas_src_install

	numeric-int64-multibuild_install_alternative cblas reference /usr/include/cblas.h cblas/cblas.h

	multilib_install_wrappers

	dodoc README
	docinto examples
	dodoc examples/*.c
}
