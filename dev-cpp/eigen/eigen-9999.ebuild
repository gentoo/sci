# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

if [[ ${PV} == "9999" ]] ; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/eigen/eigen"
	SRC_URI=""
	KEYWORDS=""
else
	inherit vcs-snapshot
	SRC_URI="
		http://bitbucket.org/eigen/eigen/get/${PV}.tar.bz2 -> ${P}.tar.bz2
		https://bitbucket.org/eigen/eigen/commits/1d71b1341c03a7c485289be2c8bd906a259c0487/raw/ -> ${P}-cmake.patch
		"
	PATCHES=( "${DISTDIR}"/${P}-cmake.patch	)
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

inherit alternatives-2 cmake-utils fortran-2 multilib

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/"

SLOT="3"
LICENSE="MPL-2.0"
IUSE="adolc doc fortran fftw gmp metis mkl pastix sparse static-libs test"

CDEPEND="
	adolc? ( sci-libs/adolc[sparse?] )
	fftw? ( sci-libs/fftw:3.0 )
	gmp? ( dev-libs/gmp:0 dev-libs/mpfr:0 )
	metis? ( sci-libs/metis )
	mkl? ( sci-libs/mkl )
	pastix? ( sci-libs/pastix )
	sparse? (
		dev-cpp/sparsehash
		sci-libs/cholmod[metis?]
		sci-libs/spqr
		sci-libs/superlu
		sci-libs/umfpack )"
DEPEND="
	doc? ( app-doc/doxygen[dot,latex] )
	test? ( ${CDEPEND} )"

RDEPEND="
	!dev-cpp/eigen:0
	${CDEPEND}"

src_prepare() {
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e "s:/bin/bash:${EPREFIX}/bin/bash:g" \
		cmake/*.cmake || die
	sed -i \
		-e "/DESTINATION/s:lib:$(get_libdir):g" \
		{blas,lapack}/CMakeLists.txt || die

	# TOFIX: static-libs for blas are always built with PIC
	use static-libs || sed -i \
		-e "/add_dependencies/s/eigen_[a-z]*_static//g" \
		-e "/TARGETS/s/eigen_[a-z]*_static//g" \
		-e "/add_library(eigen_[a-z]*_static/d" \
		-e "/target_link_libraries(eigen_[a-z]*_static/d" \
		{blas,lapack}/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	# TOFIX: is it worth fixing all the automagic given no library is built?
	# cmake has buggy disable_testing feature, so leave it for now
	local mycmakeargs=(
		-DDART_TESTING_TIMEOUT=300
		-DEIGEN_BUILD_BTL=OFF
	)
	export VARTEXFONTS="${T}/fonts"
	CMAKE_BUILD_TYPE="release" cmake-utils_src_configure
	# use fortran && FORTRAN_LIBS="blas lapack" not ready
	use fortran && FORTRAN_LIBS="blas"
}

src_compile() {
	local targets="${FORTRAN_LIBS}"
	use doc && targets+=" doc"
	use test && targets+=" check"
	cmake-utils_src_compile ${targets}
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${BUILD_DIR}"/doc/html/*
	local x
	for x in ${FORTRAN_LIBS}; do
		local libname="eigen_${x}"
		emake DESTDIR="${D}" -C "${BUILD_DIR}/${x}" install ${libname}
		cat > ${libname}.pc <<-EOF
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ${PN}
			Description: ${DESCRIPTION} ${x^^} implementation
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -l${libname}
			Libs.private: -lm
			$([[ ${x} == lapack ]] && echo "Requires: blas")
		EOF
		alternatives_for ${x} eigen 0 \
			/usr/$(get_libdir)/pkgconfig/${x}.pc ${libname}.pc
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${libname}.pc
	done
}
