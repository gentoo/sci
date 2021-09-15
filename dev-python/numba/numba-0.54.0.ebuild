# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

DISTUTILS_USE_SETUPTOOLS=rdepend
inherit optfeature multiprocessing distutils-r1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="https://numba.pydata.org/
	https://github.com/numba"
SRC_URI="https://github.com/numba/numba/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="openmp threads"

RDEPEND="
	>=dev-python/llvmlite-0.37.0[${PYTHON_USEDEP}]
	<dev-python/llvmlite-0.38.0
	>=dev-python/numpy-1.17.0[${PYTHON_USEDEP}]
	threads? ( >=dev-cpp/tbb-2019.5 )
"
BDEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
"

DISTUTILS_IN_SOURCE_BUILD=1
distutils_enable_tests unittest
distutils_enable_sphinx docs/source dev-python/numpydoc dev-python/sphinx_rtd_theme

PATCHES=(
	"${FILESDIR}/${PN}-0.52.0-skip_tests.patch"
)

pkg_setup() {
	if ! use openmp; then
		export NUMBA_DISABLE_OPENMP=1 || die
	else
		unset NUMBA_DISABLE_OPENMP || die
	fi
	if ! use threads; then
		export NUMBA_DISABLE_TBB=1 || die
	else
		unset NUMBA_DISABLE_TBB || die
		export TBBROOT="${EPREFIX}/usr" || die
	fi
}

python_prepare_all() {
	# This conf.py only works in a git repo
	if use doc; then
		git init -q || die
		git config user.email "larry@gentoo.org" || die
		git config user.name "Larry the Cow" || die
		git add . || die
		git commit -m "init" || die
	fi
	distutils-r1_python_prepare_all
}

python_compile() {
	# FIXME: parallel python building fails. See Portage bug #614464 and
	# gentoo/sci issue #1080.
	export MAKEOPTS=-j1 || die
	distutils-r1_python_compile
}

# https://numba.pydata.org/numba-doc/latest/developer/contributing.html?highlight=test#running-tests
python_test() {
	distutils_install_for_testing
	${EPYTHON} setup.py build_ext --inplace || die \
		"${EPYTHON} failed to build_ext"
	${EPYTHON} runtests.py -m $(makeopts_jobs) || die \
		"${EPYTHON} failed unittests"
}

pkg_postinst() {
	optfeature "compile cuda code" dev-util/nvidia-cuda-sdk
}
