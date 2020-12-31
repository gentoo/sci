# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 eutils

MY_PN="scikit-video"
MY_HASH="87c7113a84b50679d9853ba81ba34b557f516b05"

DESCRIPTION="Video processing in Python"
HOMEPAGE="https://scikit-image.org/"
SRC_URI="https://github.com/scikit-video/scikit-video/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-video/ffmpeg
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
	media-video/mediainfo
"

S="${WORKDIR}/${MY_PN}-${MY_HASH}"

distutils_enable_tests pytest
