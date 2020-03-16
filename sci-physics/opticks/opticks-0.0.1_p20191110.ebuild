# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit mercurial cmake-utils cuda flag-o-matic python-any-r1

EHG_REPO_URI="https://bitbucket.org/simoncblyth/${PN}"
EHG_REVISION="a580e704afe9d2c138072835e986542c835c29fc"

DESCRIPTION="GPU Optical Photon Simulation for Particle Physics"
HOMEPAGE="https://simoncblyth.bitbucket.io"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/nvidia-cuda-sdk
	dev-libs/optix
	media-gfx/openmesh
	media-libs/DualContouringSample
	media-libs/implicitmesher
	media-libs/assimp
	media-libs/glfw
	media-libs/glew:0
	media-libs/glm
	media-libs/yocto-gl
	media-libs/imgui
	sci-physics/geant[gdml]"
DEPEND="sci-physics/opticks-okconf
	dev-libs/boost
	dev-util/bcm
	dev-util/plog
	${PYTHON_DEPS}
	${RDEPEND}"
PATCHES=( "${FILESDIR}"/opticks-0.0.1_split-cmake.patch
	"${FILESDIR}"/opticks-0.0.1_okconf.patch
	"${FILESDIR}"/opticks-0.0.1_cuda-helper.patch
	"${FILESDIR}"/opticks-0.0.1_extG4-CLHEP.patch
	"${FILESDIR}"/opticks-0.0.1_python-helper.patch )
CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindBoost"

pkg_setup() {
	# opticks combined build is not parallel.
	export MAKEOPTS="-j1"

	python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# do not add the default '-O2' that results in nvcc error of
	# nvcc fatal   : redefinition of argument 'optimize'
	export NVCCFLAGS=
	cuda_src_prepare

	# do not install the tests
	for f in $(find -path '*/tests/CMakeLists.txt'); do
		ebegin "Removing installation phrase from ${f}"
		sed '/install(TARGETS/d' -i ${f}
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
	sed -e '/install(FILES/,/)/d' -i ggeo/tests/CMakeLists.txt
	eend $?
	ebegin "Moving glsl into share in oglrap/CMakeLists.txt"
	sed -e "s,gl),share/${PN}/gl)," -i oglrap/CMakeLists.txt
	eend $?

	ebegin "Removing python bindings from sysrap/CMakeLists.txt"
	sed -e "/py\/opticks\/sysrap/d" -i sysrap/CMakeLists.txt
	eend $?

	# integrated build OpticksBuildOptions is included at the top
	for f in */CMakeLists.txt; do
		ebegin "Removing OpticksBuildOptions include from ${f}"
		sed '/OpticksBuildOptions/d' -i ${f}
		eend $?
	done

	# include/Opticks instead of OpticksCore
	sed -e 's,include/OpticksCore,include/Opticks,' -i optickscore/OpticksFlags.cc \
		-i npy/Types.cpp \
		-i ana/base.py \
		-i ana/enum.py
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${S}"/cmake/Modules
		-DOptiX_INSTALL_DIR="${EPREFIX}/opt/optix"
		-DCUDA_SDK_ROOT_DIR="${EPREFIX}/opt/cuda/sdk"
		-DCOMPUTE_CAPABILITY=61
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS}"
		-DBoost_NO_BOOST_CMAKE=ON
		--target all
	)
	cmake-utils_src_configure
}
