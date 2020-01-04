# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial cmake-utils cuda

EHG_REPO_URI="https://bitbucket.org/simoncblyth/${PN//-*}"
EHG_REVISION="a580e704afe9d2c138072835e986542c835c29fc"

DESCRIPTION="GPU Optical Photon Simulation for Particle Physics"
HOMEPAGE="https://simoncblyth.bitbucket.io"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/nvidia-cuda-toolkit:=
	dev-libs/optix"
DEPEND="dev-util/cmake
	dev-libs/boost
	dev-util/bcm
	dev-util/plog
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.1_p20191110-no_lib_install.patch
)

src_prepare() {
	cmake-utils_src_prepare
	cuda_src_prepare

	rm -f CMakeLists.txt* || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${S}"/cmake/Modules
		-DOptiX_INSTALL_DIR="${EPREFIX}/opt/optix"
		-DCUDA_SDK_ROOT_DIR="${EPREFIX}/opt/cuda/sdk"
		-DCOMPUTE_CAPABILITY=61
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS}"
	)
	CMAKE_USE_DIR=${S}/${PN##*-} cmake-utils_src_configure
}
