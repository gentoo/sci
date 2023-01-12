# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
LUA_COMPAT=( lua5-{1..3} )

inherit lua-single cmake python-single-r1

MY_PN="SimpleITK"

DESCRIPTION="Layer on top of ITK for rapid prototyping, education and interpreted languages."
HOMEPAGE="https://simpleitk.org/"
SRC_URI="
	https://github.com/SimpleITK/SimpleITK/releases/download/v${PV}/SimpleITK-${PV}.tar.gz
	https://github.com/SimpleITK/SimpleITK/releases/download/v${PV}/SimpleITKData-${PV}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="dev-lang/swig"
RDEPEND="
	${LUA_DEPS}
	dev-cpp/gtest
	sci-libs/itk
	dev-python/virtualenv
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-module.patch"
	"${FILESDIR}/${P}-int-cast.patch"
)

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake_src_prepare
	cp -rf "../${MY_PN}-${PV}/.ExternalData" "${BUILD_DIR}/" || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_GTEST=ON
		-DUSE_SYSTEM_ITK=ON
		-DUSE_SYSTEM_LUA=ON
		-DUSE_SYSTEM_SWIG=ON
		-DUSE_SYSTEM_VIRTUALENV=ON
		-DBUILD_TESTING:BOOL=OFF
		-DSimpleITK_FORBID_DOWNLOADS=ON
		-DSimpleITK_PYTHON_USE_VIRTUALENV:BOOL=OFF
		-DSimpleITK_EXPLICIT_INSTANTIATION=OFF
		-DModule_SimpleITKFilters:BOOL=ON
		-DExternalData_OBJECT_STORES:STRING="${BUILD_DIR}/.ExternalData"
		-DSimpleITK_INSTALL_LIBRARY_DIR=$(get_libdir)
	)
	cmake_src_configure
}
