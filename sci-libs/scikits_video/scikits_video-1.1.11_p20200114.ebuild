# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 eutils virtualx

MY_PN="scikit-video"
MY_HASH="66919e0828410938a4d52f37987b07f7f5de96af"

DESCRIPTION="Video processing in Python"
HOMEPAGE="https://scikit-image.org/"
SRC_URI="https://github.com/scikit-video/scikit-video/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| ( media-video/ffmpeg media-video/libav )
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	media-video/mediainfo
"
DEPEND="${RDEPEND}
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_PN}-${MY_HASH}"

python_test() {
	nosetests -v || die
}
