# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda test"

COMMON_DEPEND="
	dev-python/av[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/pytorch[cuda?,${PYTHON_USEDEP}]
	virtual/ffmpeg
"
DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-qt/qtcore:5"

S="${WORKDIR}/vision-${PV}"

distutils_enable_tests pytest

PATCHES=("${FILESDIR}/${PN}-include-dir.patch")

pkg_setup() {
	if use cuda; then
		export FORCE_CUDA=1
		export TORCH_CUDA_ARCH_LIST="3.5;3.7;5.0;5.2;5.3;6.0;6.0+PTX;6.1;6.1+PTX;6.2;6.2+PTX;7.0;7.0+PTX;7.2;7.2+PTX;7.5;7.5+PTX"
	fi
}
