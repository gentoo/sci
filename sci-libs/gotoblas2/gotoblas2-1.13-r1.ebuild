# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NUMERIC_MODULE_NAME=goto2

inherit eutils numeric-int64-multibuild fortran-2 multilib toolchain-funcs

MYPN="GotoBLAS2"
MYP="${MYPN}-${PV}_bsd"

DESCRIPTION="Fast implementations of the Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.tacc.utexas.edu/tacc-projects/gotoblas2/"
# change to gentoo mirror when in
SRC_URI="http://dev.gentoo.org/~bicatali/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+incblas +openmp static-libs threads"

REQUIRED_USE="|| ( openmp threads )"

S="${WORKDIR}/${MYPN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{dynamic,sharedlibs,fcheck,aliasing}.patch
	# respect LDFLAGS
	sed -i -e '/^LDFLAGS\s*=/d' Makefile.* || die
	sed -i \
		-e "/^COMMON_OPT/s/-O2/${CFLAGS}/" \
		Makefile.rule || die
	# fix executable stacks
	local i
	for i in $(find . -name \*.S); do
		cat >> ${i} <<-EOF
			#if defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done
	numeric-int64-multibuild_copy_sources
}

src_configure() {
	myconfigure() {
		sed \
			-e "s:^#\s*\(NO_LAPACK\)\s*=.*:\1=1:" \
			-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC):" \
			-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC):" \
			-e "s:^#\s*\(USE_THREAD\)\s*=.*:\1=$(usex threads 1 0):" \
			-e "s:^#\s*\(USE_OPENMP\)\s*=.*:\1=$(usex openmp 1 ""):" \
			-e "s:^#\s*\(DYNAMIC_ARCH\)\s*=.*:\1=1:" \
			-e "s:^#\s*\(INTERFACE64\)\s*=.*:\1=$(numeric-int64_is_int64_build && echo 1 || echo ""):" \
			-e "s:^#\s*\(NO_CBLAS\)\s*=.*:\1=$(usex incblas 1 ""):" \
			-i Makefile.rule || die
		if numeric-int64_is_int64_build; then
			sed \
				-e 's:libgoto2:libgoto2_int64:g' \
				-i Makefile* || die
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir myconfigure
}

src_compile() {
	mycompile() {
		if numeric-int64_is_static_build; then
			use static-libs && emake clean && emake libs NEED_PIC=
		else
			mkdir solibs || die
			emake libs shared && mv *$(get_libname) solibs/ || die
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir mycompile
}

src_test() {
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir emake tests
}

src_install() {
	myinstall() {
		local profname=$(numeric-int64_get_module_name)
		local libname=libgoto2
		local libs="-L\${libdir} -lm"
		if numeric-int64_is_int64_build; then
			libs+=" -lgoto2_int64"
		else
			libs+=" -lgoto2"
		fi
		use threads && libs+=" -pthread"

		numeric-int64_is_static_build && libname=libgoto2_int64

		if numeric-int64_is_static_build; then
			dolib.a lib*.a
		else
			dolib.so solibs/lib*$(get_libname)

			create_pkgconfig \
				--name "${MYPN}" \
				--libs "${libs}" \
				--cflags "-I\${includedir}/${PN}" \
				${profname}
		fi

		if use incblas; then
			insinto /usr/include/${PN}
			doins cblas.h
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir myinstall

	numeric-int64-multibuild_install_alternative blas ${NUMERIC_MODULE_NAME}
	numeric-int64-multibuild_install_alternative cblas ${NUMERIC_MODULE_NAME} /usr/include/cblas.h ${PN}/cblas.h

	dodoc 01Readme.txt 03FAQ.txt 05LargePage 06WeirdPerformance

	if [[ ${CHOST} == *-darwin* ]] ; then
		cd "${ED}"/usr/$(get_libdir) || die
		local d
		for d in *.dylib ; do
			ebegin "correcting install_name of ${d}"
			install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${d}" "${d}" || die
			eend $?
		done
	fi
}
