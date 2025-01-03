# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="SoundFile is an audio library based on libsndfile, CFFI, and NumPy"
HOMEPAGE="https://github.com/bastibe/python-soundfile/"
SRC_URI="
	https://github.com/bastibe/python-soundfile/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-soundfile-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libsndfile
	dev-python/numpy[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
	' 'python*')
"

distutils_enable_tests pytest
