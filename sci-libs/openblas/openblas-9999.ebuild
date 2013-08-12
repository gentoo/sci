# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/xianyi/OpenBLAS.git"
EGIT_MASTER="develop"

inherit eutils toolchain-funcs alternatives-2 multilib fortran-2 git-2

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
KEYWORDS=""
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${PN}-gentoo.patch"

LICENSE="BSD"
SLOT="0"

IUSE="int64 dynamic openmp static-libs threads"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	# lapack and lapacke are not modified from upstream lapack
	sed -i \
		-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC):" \
		-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC):" \
		-e "s:^#\s*\(COMMON_OPT\)\s*=.*:\1=${CFLAGS}:" \
		-e "s:^#\s*\(NO_LAPACK\)\s*=.*:\1=1:" \
		-e "s:^#\s*\(NO_LAPACKE\)\s*=.*:\1=1:" \
		Makefile.rule || die
}

openblas_compile() {
	local profname=$1
	einfo "Compiling profile ${profname}"
	# cflags already defined twice
	unset CFLAGS
	emake clean
	emake libs shared ${openblas_flags}
	mkdir -p libs && mv libopenblas* libs/
	# avoid pic when compiling static libraries, so re-compiling
	if use static-libs; then
		emake clean
		emake libs ${openblas_flags} NO_SHARED=1 NEED_PIC=
		mv libopenblas* libs/
	fi
	cat <<-EOF > ${profname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lopenblas
		Libs.private: -lm
		Cflags: -I\${includedir}/${PN}
	EOF
}

src_compile() {
	# openblas already does multi-jobs
	MAKEOPTS+=" -j1"
	openblas_flags=""
	local openblas_name=openblas
	use dynamic && \
		openblas_name+="-dynamic" && \
		openblas_flags+=" DYNAMIC_ARCH=1 TARGET=GENERIC NUM_THREADS=64 NO_AFFINITY=1"
	use int64 && \
		openblas_name+="-int64" && \
		openblas_flags+=" INTERFACE64=1"

	# choose posix threads over openmp when the two are set
	# yet to see the need of having the two profiles simultaneously
	if use threads; then
		openblas_name+="-threads"
		openblas_flags+=" USE_THREAD=1 USE_OPENMP=0"
	elif use openmp; then
		openblas_name+="-openmp"
		openblas_flags+=" USE_THREAD=0 USE_OPENMP=1"
	fi
	openblas_compile ${openblas_name}
	mv libs/libopenblas* . || die
}

src_test() {
	emake tests ${openblas_flags}
}

src_install() {
	local pcfile
	for pcfile in *.pc; do
		local profname=${pcfile%.pc}
		emake install \
			PREFIX="${ED}"usr ${openblas_flags} \
			OPENBLAS_INCLUDE_DIR="${ED}"usr/include/${PN} \
			OPENBLAS_LIBRARY_DIR="${ED}"usr/$(get_libdir)
		use static-libs || rm "${ED}"usr/$(get_libdir)/lib*.a
		alternatives_for blas ${profname} 0 \
			/usr/$(get_libdir)/pkgconfig/blas.pc ${pcfile}
		alternatives_for cblas ${profname} 0 \
			/usr/$(get_libdir)/pkgconfig/cblas.pc ${pcfile} \
			/usr/include/cblas.h ${PN}/cblas.h
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${pcfile}
	done

	dodoc GotoBLAS_{01Readme,03FAQ,04FAQ,05LargePage,06WeirdPerformance}.txt
	dodoc *md Changelog.txt

	if [[ ${CHOST} == *-darwin* ]] ; then
		cd "${ED}"/usr/$(get_libdir)
		local d
		for d in *.dylib ; do
			ebegin "Correcting install_name of ${d}"
			install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${d}" "${d}"
			eend $?
		done
	fi
}
