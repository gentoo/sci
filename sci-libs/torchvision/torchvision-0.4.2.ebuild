# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_OPTIONAL=1

inherit cmake-utils distutils-r1

DESCRIPTION="Datasets, Transforms and Models specific to Computer Vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

IUSE="cuda ffmpeg +python"

REQUIRED_USE="ffmpeg? ( python )"

DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	ffmpeg? ( virtual/ffmpeg )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		sci-libs/scipy
		>=dev-python/pillow-4.1.1
	)
	sci-libs/pytorch[python?,cuda?]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Control-support-of-ffmpeg.patch"
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${P//torch/}" "${S}"
}

src_configure() {
	cmake-utils_src_configure

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake-utils_src_install

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		distutils-r1_src_install
	fi

	local multilib_failing_files=(
		libtorchvision.so
	)

	for file in ${multilib_failing_files[@]}; do
		mv -f "${D}/usr/lib/$file" "${D}/usr/lib64"
	done

}
