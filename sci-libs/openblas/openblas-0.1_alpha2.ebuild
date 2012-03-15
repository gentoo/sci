# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs alternatives-2 git-2

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
EGIT_REPO_URI="git://github.com/xianyi/OpenBLAS.git"
EGIT_COMMIT="v0.1alpha2.2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos ~ppc-macos ~x64-macos"

IUSE="+incblas int64 dynamic openmp static-libs threads"

RDEPEND="virtual/fortran"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}"

pkg_setup() {
	ewarn "If the compilation fails, try setting the TARGET environment variable"
	ewarn "to your CPU's codename and run emerge again."

	SHLIB=so
	if [[ ${CHOST} == *-darwin* ]] ; then
		SHLIB=dylib
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-{sharedlibs,aliasing}.patch
	# respect LDFLAGS
	sed -i -e '/^LDFLAGS\s*=/d' Makefile.* || die
	# respect CFLAGS only if dynamic flag not enabled
	if ! use dynamic; then
		sed -i \
			-e "/^COMMON_OPT/s/-O2/${CFLAGS}/" \
			Makefile.rule || die
	fi
	# fix executable stacks
	local i
	for i in $(find . -name \*.S); do
		cat >> ${i} <<-EOF
			#if defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done
}

src_configure() {
	local use_openmp=$(use openmp && echo 1)
	use threads && use openmp && use_openmp="" && \
		einfo "openmp and threads enabled: using threads"
	sed -i \
		-e "s:^#\s*\(NO_LAPACK\)\s*=.*:\1=1:" \
		-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC):" \
		-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC):" \
		-e "s:^#\s*\(USE_THREAD\)\s*=.*:\1=$(use threads && echo 1 || echo 0):" \
		-e "s:^#\s*\(USE_OPENMP\)\s*=.*:\1=${use_openmp}:" \
		-e "s:^#\s*\(DYNAMIC_ARCH\)\s*=.*:\1=$(use dynamic && echo 1):" \
		-e "s:^#\s*\(INTERFACE64\)\s*=.*:\1=$(use int64 && echo 1):" \
		-e "s:^#\s*\(NO_CBLAS\)\s*=.*:\1=$(use incblas || echo 1):" \
		Makefile.rule || die
}

src_compile() {
	mkdir solibs
	emake libs shared && mv *."${SHLIB}" solibs/
	use static-libs && emake clean && emake libs NEED_PIC=
}

src_test() {
	emake tests
}

src_install() {
	local profname=${PN} threads
	use int64 && profname=${profname}-int64
	if use threads; then
		threads="-pthread"
		profname=${profname}-threads
	elif use openmp; then
		profname=${profname}-openmp
	fi

	dolib.so solibs/lib*."${SHLIB}"
	use static-libs && dolib.a lib*.a

	# create pkg-config file and associated eselect file
	cat <<-EOF > ${profname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lopenblas -lm ${threads}
	EOF

	alternatives_for blas ${profname} 0 \
		"/usr/$(get_libdir)/pkgconfig/blas.pc" "${profname}.pc"

	if use incblas; then
		echo >> ${profname}.pc "Cflags: -I\${includedir}/${PN}"
		insinto /usr/include/${PN}
		doins cblas.h common*.h config.h param.h
		alternatives_for cblas ${profname} 0 \
			"/usr/$(get_libdir)/pkgconfig/cblas.pc" "${profname}.pc" \
			"/usr/include/cblas.h" "${PN}/cblas.h"
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${profname}.pc
	dodoc GotoBLAS_{01Readme,03FAQ,04FAQ,05LargePage,06WeirdPerformance}.txt

	if [[ ${CHOST} == *-darwin* ]] ; then
		cd "${ED}"/usr/$(get_libdir)
		for d in *.dylib ; do
			ebegin "correcting install_name of ${d}"
			install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${d}" "${d}"
			eend $?
		done
	fi
}
