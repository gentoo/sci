# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
ROCM_SKIP_GLOBALS=1
inherit cuda distutils-r1 multiprocessing rocm

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vision-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda rocm test"
REQUIRED_USE="?? ( cuda rocm )"
RESTRICT="!test? ( test )"

distutils_enable_tests pytest

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
	sci-libs/caffe2[cuda?,rocm?]
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	media-video/ffmpeg:=
"
DEPEND="${RDEPEND}"

src_compile()
{
	export MAX_JOBS="$(makeopts_jobs)" # Let ninja respect MAKEOPTS

	# Ensure some ext_module sources are compiled before linking
	export MAKEOPTS="-j1"

	use cuda && export NVCC_FLAGS="$(cuda_gccdir -f | tr -d \")"
	use rocm && addpredict /dev/kfd

	distutils-r1_src_compile
}

python_test() {
	use rocm && check_amdgpu

	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	rm -rf torchvision || die

	epytest
}
