# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED="blas-provider test"

inherit alternatives-2 cmake-utils cuda fortran-2 numeric

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/"
SRC_URI="https://bitbucket.org/eigen/eigen/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="3"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="altivec c++11 blas-provider cuda debug doc neon openmp static-libs test" #zvector vsx

IUSE_CPU_FLAGS=" avx avx2 f16c fma3 sse2 sse3 sse4_1 sse4_2 ssse3" #x87
IUSE+=" ${IUSE_CPU_FLAGS// / cpu_flags_x86_}"

RDEPEND="!dev-cpp/eigen:0"
DEPEND="
	doc? ( app-doc/doxygen[dot,latex] )
	test? (
		dev-libs/gmp:0
		dev-libs/mpfr:0
		media-libs/freeglut
		media-libs/glew
		sci-libs/adolc[sparse]
		sci-libs/cholmod
		sci-libs/fftw:3.0
		sci-libs/pastix
		sci-libs/umfpack
		sci-libs/scotch
		sci-libs/spqr
		sci-libs/superlu
		dev-qt/qtcore:4
		virtual/opengl
		virtual/pkgconfig
		cuda? ( dev-util/nvidia-cuda-toolkit )
	)
"
# Missing:
# METIS-5
# GOOGLEHASH

src_unpack() {
	default
	mv ${PN}* ${P} || die
}

src_prepare() {
	sed -e 's:-g2::g' \
		-i cmake/EigenConfigureTesting.cmake || die

	sed -e "/add_subdirectory(demos/d" \
		-i CMakeLists.txt || die

	if ! use test; then
		sed \
			-e "/add_subdirectory(test/d" \
			-e "/add_subdirectory(lapack/d" \
			-i CMakeLists.txt || die

		if ! use blas-provider; then
			sed \
				-e "/add_subdirectory(blas/d" \
				-i CMakeLists.txt || die
		fi
	fi
	sed -e "/Unknown build type/d" \
		-i CMakeLists.txt || die

	sed -i \
		-e "/DESTINATION/s:lib:$(get_libdir):g" \
		{blas,lapack}/CMakeLists.txt || die

	if ! use static-libs; then
		sed \
			-e "/add_dependencies/s/eigen_[a-z]*_static//g" \
			-e "/TARGETS/s/eigen_[a-z]*_static//g" \
			-e "/add_library(eigen_[a-z]*_static/d" \
			-e "/target_link_libraries(eigen_[a-z]*_static/d" \
			-i {blas,lapack}/CMakeLists.txt || die
	fi

	use cuda && cuda_src_prepare

	cmake-utils_src_prepare
}

src_compile() {
	cmake-utils_src_compile
	use blas-provider && cmake-utils_src_compile blas
	use doc && cmake-utils_src_compile doc
}

src_test() {
	local mycmakeargs=(
		-DEIGEN_TEST_ALTIVEC="$(usex altivec)"
		-DEIGEN_TEST_CXX11="$(usex c++11)"
		-DEIGEN_TEST_CUDA="$(usex cuda)"
		-DEIGEN_TEST_OPENMP="$(usex openmp)"
		-DEIGEN_TEST_AVX="$(usex cpu_flags_x86_avx)"
		-DEIGEN_TEST_AVX512="$(usex cpu_flags_x86_avx2)"
		-DEIGEN_TEST_F16C="$(usex cpu_flags_x86_f16c)"
		-DEIGEN_TEST_FMA="$(usex cpu_flags_x86_fma3)"
		-DEIGEN_TEST_SSE3="$(usex cpu_flags_x86_sse3)"
		-DEIGEN_TEST_SSE4_1="$(usex cpu_flags_x86_sse4_1)"
		-DEIGEN_TEST_SSE4_2="$(usex cpu_flags_x86_sse4_2)"
		-DEIGEN_TEST_SSSE3="$(usex cpu_flags_x86_ssse3)"
		-DEIGEN_TEST_NEON64="$(usex neon)"
#		-DEIGEN_TEST_X87="$(usex cpu_flags_x86_x87)"
	)
	cmake-utils_src_configure
	cmake-utils_src_compile blas
	cmake-utils_src_compile buildtests
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/html

	if use blas-provider; then
		local libname="eigen_blas"
		emake DESTDIR="${D}" -C "${BUILD_DIR}/blas" install ${libname}
		create_pkgconfig \
			--description "${DESCRIPTION} blas implementation" \
			--libs "-l${libname}" \
			--libs-private "-lm" \
			${libname}
		alternatives_for blas eigen 0 \
			/usr/$(get_libdir)/pkgconfig/blas.pc ${libname}.pc
	fi

	# Debian installs it and some projects started using it.
	insinto /usr/share/cmake/Modules/
	doins "${S}/cmake/FindEigen3.cmake"
}
