# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 git-r3

DESCRIPTION="Python library for audio and music analysis"
HOMEPAGE="https://github.com/librosa/librosa"
EGIT_REPO_URI="$HOMEPAGE"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.22.2[${PYTHON_USEDEP}]
	>=dev-python/audioread-2.1.9[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.14[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/numba-0.51.0[${PYTHON_USEDEP}]
	>=dev-python/soundfile-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/pooch-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/soxr-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.1.1[${PYTHON_USEDEP}]
	>=dev-python/lazy-loader-0.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov[a-z-]*\(=\| \)[a-z-]*::g' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		#Network
		'tests/test_util.py::test_example'
		'tests/test_util.py::test_cite_badversion'
		'tests/test_util.py::test_cite_unreleased'
		'tests/test_util.py::test_cite_released'
		'tests/test_core.py::test_load'

		#Missing test dependencies(resampy, samplerate)
		'tests/test_core.py::test_resample_mono'
		'tests/test_core.py::test_resample_scale'
		'tests/test_core.py::test_resample_stereo'
		'tests/test_multichannel.py::test_resample_multichannel'
		'tests/test_multichannel.py::test_resample_highdim_axis'
		'tests/test_multichannel.py::test_resample_highdim'
	)

	epytest -p pytest_mpl
}
