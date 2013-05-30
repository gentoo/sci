# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

FORTRAN_STANDARD="77 90"
inherit eutils fortran-2 multilib toolchain-funcs versionator

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="http://icl.cs.utk.edu/magma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/${PN}/pubs/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fermi kepler static-libs"

RDEPEND="
	dev-util/nvidia-cuda-toolkit
	virtual/cblas
	virtual/fortran
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# We have to have write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="userpriv"

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
	epatch "${FILESDIR}"/${PN}-1.2.1-no-cuda-driver.patch

	# http://icl.cs.utk.edu/magma/forum/viewtopic.php?f=2&t=789
	sed -i -e 's/void magmaSetDevice/static void magmaSetDevice/' src/*getrf2_mgpu.cpp

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
		INC = -I"${EPREFIX}/opt/cuda/include" -DADD_ -DCUBLAS_GFORTRAN
		OPTS = ${CFLAGS} -fPIC
		FOPTS = ${FFLAGS} -fPIC -x f95-cpp-input
		F77OPTS = ${FFLAGS} -fPIC
		NVOPTS = -DADD_ --compiler-options '-fPIC ${CFLAGS}' -DUNIX
		LOADER = $(tc-getFC)
		LIBBLAS = $($(tc-getPKG_CONFIG) --libs cblas)
		LIBLAPACK = $($(tc-getPKG_CONFIG) --libs lapack)
		CUDADIR = "${EPREFIX}/opt/cuda"
		LIBCUDA = -L\$(CUDADIR)/$(get_libdir) -lcublas -lcudart
		LIB = -pthread -lm -ldl \$(LIBCUDA) \$(LIBBLAS) \$(LIBLAPACK) -lstdc++
	EOF
	if use kepler; then
		echo >> make.inc "GPU_TARGET = Kepler"
	elif use fermi; then
		echo >> make.inc "GPU_TARGET = Fermi"
	else # See http://icl.cs.utk.edu/magma/forum/viewtopic.php?f=2&t=227
		echo >> make.inc "GPU_TARGET = Tesla"
	fi

	# see http://icl.cs.utk.edu/magma/forum/viewtopic.php?f=2&t=532
#	sed -i -e 's:[cz]heevd_m.cpp::g' src/Makefile.src src/Makefile
	sed -i -e 's:[cz]hegvd_m.cpp::g' src/Makefile.src src/Makefile
}

src_compile() {
	# restrict to -j1 otherwise the static archive is not complete
	emake -j1 lib
	LINK=$(tc-getFC) static_to_shared lib/libmagmablas.a -lm -lpthread -ldl \
		-lcublas -lcudart -L"${EPREFIX}"/opt/cuda/$(get_libdir) -lstdc++ \
		$($(tc-getPKG_CONFIG) --libs cblas) $($(tc-getPKG_CONFIG) --libs lapack)
	static_to_shared lib/libmagma.a -lm -lpthread -ldl -lcublas -lcudart \
		-L"${EPREFIX}"/opt/cuda/$(get_libdir) -lmagmablas \
		-Llib $($(tc-getPKG_CONFIG) --libs cblas) $($(tc-getPKG_CONFIG) --libs lapack)
	if use static-libs; then
		emake cleanall
		sed 's/-fPIC//g' make.inc
		emake lib
	fi
}

src_test() {
	emake test lapacktest
	cd testing/lin
	# we need to access this while running the tests
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0
	LD_LIBRARY_PATH=${S}/lib python lapack_testing.py || die
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
