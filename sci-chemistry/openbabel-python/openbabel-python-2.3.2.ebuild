# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python2_6 python2_7 python3_1 python3_2)

inherit cmake-utils eutils multilib python-r1

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	!sci-chemistry/babel
	~sci-chemistry/openbabel-${PV}
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	>=dev-lang/swig-2"

S="${WORKDIR}"/openbabel-${PV}

src_prepare() {
	epatch "${FILESDIR}/${P}-testpybel.patch"
	epatch "${FILESDIR}/${P}-bindings_only.patch"

	swig -python -c++ -small -O -templatereduce -naturalvar \
		-I"${EPREFIX}/usr/include/openbabel-2.0" \
		-o scripts/python/openbabel-python.cpp \
		-DHAVE_EIGEN \
		-outdir scripts/python \
		scripts/openbabel-python.i \
		|| die "Regeneration of openbabel-python.cpp failed"
}

src_configure() {
	my_impl_src_configure() {
		CMAKE_BUILD_DIR="${BUILD_DIR}"
		local mycmakeargs="${mycmakeargs}
			-DCMAKE_INSTALL_RPATH=
			-DBINDINGS_ONLY=ON
			-DBABEL_SYSTEM_LIBRARY=${EPREFIX}/usr/$(get_libdir)/libopenbabel.so
			-DOB_MODULE_PATH=${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}
			-DLIB_INSTALL_DIR=${ED}/usr/$(get_libdir)/${EPYTHON}/site-packages
			-DPYTHON_BINDINGS=ON
			-DPYTHON_EXECUTABLE=${PYTHON}
			-DPYTHON_INCLUDE_DIR=${EPREFIX}/usr/include/${EPYTHON}
			-DPYTHON_LIBRARY=${EPREFIX}/usr/$(get_libdir)/lib${EPYTHON}.so
			-DENABLE_TESTS=ON"

		cmake-utils_src_configure
	}

	python_foreach_impl my_impl_src_configure
}

src_compile() {
	my_impl_src_compile() {
		CMAKE_BUILD_DIR="${BUILD_DIR}"

		cmake-utils_src_make bindings_python
	}

	python_foreach_impl my_impl_src_compile
}

src_test() {
	my_impl_src_test() {
		CMAKE_BUILD_DIR="${BUILD_DIR}"
		ln -s "${EPREFIX}/usr/bin/babel" bin/babel
		ln -s "${EPREFIX}/usr/bin/obabel" bin/obabel

		cmake-utils_src_test -R py
	}

	python_foreach_impl my_impl_src_test
}

src_install() {
	python_foreach_impl cmake -DCOMPONENT=bindings_python -P cmake_install.cmake
}
