# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

FORTRAN_STANDARD="77 90"
inherit eutils fortran-2 toolchain-funcs versionator multilib

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="http://icl.cs.utk.edu/magma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fermi static-libs tesla"

RDEPEND="dev-util/nvidia-cuda-toolkit
	virtual/cblas
	virtual/fortran
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-duplicate-symbols.patch \
		"${FILESDIR}"/${P}-no-cuda-driver.patch

	# distributed pc file not so useful so replace it
	cat <<-EOF > ${PN}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/${PN}
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lmagma -lmagmablas
		Libs.private: -lm -lpthread -ldl -lcublas -lcudart
		Cflags: -I\${includedir}
		Requires: cblas lapack
	EOF
}

src_configure() {
	cat <<-EOF > make.inc
		ARCH = $(tc-getAR)
		ARCHFLAGS = cr
		RANLIB = $(tc-getRANLIB)
		NVCC = nvcc
		CC = $(tc-getCXX)
		FORT = $(tc-getFC)
		INC = -I${EPREFIX}/opt/cuda/include -DADD_
		OPTS = ${CFLAGS} -fPIC
		FOPTS = ${FFLAGS} -fPIC -x f95-cpp-input
		F77OPTS = ${FFLAGS} -fPIC
		NVOPTS = -DADD_ --compiler-options '-fPIC ${CFLAGS}' -DUNIX
		LOADER = $(tc-getFC)
		LIBBLAS = $(pkg-config --libs cblas)
		LIBLAPACK = $(pkg-config --libs lapack)
		CUDADIR = ${EPREFIX}/opt/cuda
		LIBCUDA = -L\$(CUDADIR)/$(get_libdir) -lcublas -lcudart
		LIB = -pthread -lm -ldl \$(LIBCUDA) \$(LIBBLAS) \$(LIBLAPACK) -lstdc++
	EOF
	if use fermi; then
		echo >> make.inc "GPU_TARGET = Fermi"
	elif use tesla; then
		echo >> make.inc "GPU_TARGET = Tesla"
	fi
}

src_compile() {
	emake lib
	static_to_shared lib/libmagma.a -lm -lpthread -ldl -lcublas -lcudart
	LINK=$(tc-getFC) static_to_shared lib/libmagmablas.a -lm -lpthread -ldl -lcublas -lcudart
	if use static-libs; then
		emake cleanall
		sed 's/-fPIC//g' make.inc
		emake lib
	fi
}

src_test() {
	emake test lapacktest
	cd testing/lin
	python lapack_testing.py || die
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/lib*.a
	insinto /usr/include/${PN}
	doins include/*.h
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	dodoc README ReleaseNotes
}
