# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 multiprocessing

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vision-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	media-video/ffmpeg:=
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.17.1-ffmpeg-6.patch" )

src_compile()
{
	export MAX_JOBS="$(makeopts_jobs)" # Let ninja respect MAKEOPTS

	# Ensure some ext_module sources are compiled before linking
	export MAKEOPTS="-j1"

	distutils-r1_src_compile
}
