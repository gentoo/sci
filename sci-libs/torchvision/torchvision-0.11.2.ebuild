# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/av[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-libs/pytorch[${PYTHON_USEDEP}]
	media-video/ffmpeg
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
		dev-python/mock[${PYTHON_USEDEP}]
		')
	)"

S="${WORKDIR}/vision-${PV}"

distutils_enable_tests pytest
