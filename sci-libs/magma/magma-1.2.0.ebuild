# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
FORTRAN_STANDARD="77 90"

inherit eutils fortran-2 toolchain-funcs versionator

MYP=${PN}_${PV}

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="http://icl.cs.utk.edu/magma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/${PN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fermi static-libs tesla"

RDEPEND="dev-util/nvidia-cuda-toolkit
	virtual/cblas
	virtual/lapack"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

make_shared_lib() {
	local libstatic=${1}
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	shift
	einfo "Making ${soname}"
	${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
		"$@" -o $(dirname "${libstatic}")/"${soname}" \
		|| die "${soname} failed"
	ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cblas-dotc.patch \
		"${FILESDIR}"/${P}-duplicate-symbols.patch

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
		Libs.private: -lm -lpthread -ldl -lcublas -lcudart -lcuda
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
		NVOPTS = -DADD_ --compiler-options '-fPIC ${CFLAGS}' -DUNIX
		LOADER = $(tc-getFC)
		LIBBLAS = $(pkg-config --libs cblas)
		LIBLAPACK = $(pkg-config --libs lapack)
		CUDADIR = ${EPREFIX}/opt/cuda
		LIBCUDA = -L\$(CUDADIR)/$(get_libdir) -lcublas -lcudart -lcuda
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
	make_shared_lib lib/libmagma.a
	make_shared_lib lib/libmagmablas.a
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
	dolib.so lib/lib*.so*
	use static-libs && dolib.a lib/lib*.a
	insinto /usr/include/${PN}
	doins include/*.h
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	dodoc README ReleaseNotes
}
