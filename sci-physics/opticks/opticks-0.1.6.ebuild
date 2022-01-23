# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake cuda python-any-r1

DESCRIPTION="GPU Optical Photon Simulation for Particle Physics"
HOMEPAGE="https://simoncblyth.bitbucket.io"
SRC_URI="https://bitbucket.org/simoncblyth/opticks/get/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/simoncblyth-${PN}-b75b5929b6cf"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-util/nvidia-cuda-toolkit
	dev-libs/optix
	media-libs/assimp
	media-libs/glfw
	media-libs/glew:0
	media-libs/glm
	media-libs/imgui
	sci-physics/geant[gdml]
"
DEPEND="
	dev-libs/boost:=
	dev-util/bcm
	dev-util/plog
	${PYTHON_DEPS}
	${RDEPEND}
"
# PATCHES=(
# 	"${FILESDIR}"/opticks-0.0.1_split-cmake.patch
# 	"${FILESDIR}"/opticks-0.0.1_okconf.patch
# 	"${FILESDIR}"/opticks-0.0.1_cuda-helper.patch
# 	"${FILESDIR}"/opticks-0.0.1_extG4-CLHEP.patch
# 	"${FILESDIR}"/opticks-0.0.1_python-helper.patch
# )
# CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindBoost"

pkg_setup() {
	# opticks combined build is not parallel.
	#export MAKEOPTS="-j1"

	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# do not add the default '-O2' that results in nvcc error of
	# nvcc fatal   : redefinition of argument 'optimize'
	export NVCCFLAGS=
	cuda_src_prepare

	# do not install the tests
	for f in $(find -path '*/tests/CMakeLists.txt'); do
		ebegin "Removing installation phrase from ${f}"
		sed '/install(TARGETS/d' -i ${f} || die
		eend $?
	done
	# do not install test scripts
	ebegin "Removing test scripts installation from optixrap/{,tests/}CMakeLists.txt"
	sed -e '/install(PROGRAMS/d' \
		-e '/installcache/d' \
		-i optixrap/CMakeLists.txt \
		-i optixrap/tests/CMakeLists.txt || die
	eend $?
	ebegin "Removing test scripts installation from ggeo/tests/CMakeLists.txt"
	sed -e '/install(FILES/,/)/d' -i ggeo/tests/CMakeLists.txt || die
	eend $?
	ebegin "Moving glsl into share in oglrap/CMakeLists.txt"
	sed -e "s,gl),share/${PN}/gl)," -i oglrap/CMakeLists.txt || die
	eend $?

	ebegin "Removing python bindings from sysrap/CMakeLists.txt"
	sed -e "/py\/opticks\/sysrap/d" -i sysrap/CMakeLists.txt || die
	eend $?

	# integrated build OpticksBuildOptions is included at the top
	for f in */CMakeLists.txt; do
		ebegin "Removing OpticksBuildOptions include from ${f}"
		sed '/OpticksBuildOptions/d' -i ${f} || die
		eend $?
	done

	# include/Opticks instead of OpticksCore
	sed -e 's,include/OpticksCore,include/Opticks,' -i optickscore/OpticksFlags.cc \
		-i npy/Types.cpp \
		-i ana/base.py || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${S}"/cmake/Modules
		-DOptiX_INSTALL_DIR="${EPREFIX}/opt/optix"
		-DCUDA_SDK_ROOT_DIR="${EPREFIX}/opt/cuda/sdk"
		-DCOMPUTE_CAPABILITY=61
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS}"
		-DBoost_NO_BOOST_CMAKE=ON
	)
	cmake_src_configure
}
