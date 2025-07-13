# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Data storage buffer compression and transformation codecs"
HOMEPAGE="https://github.com/zarr-developers/numcodecs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cpu_flags_x86_avx2 cpu_flags_x86_sse2"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/entrypoints[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		>=dev-python/zarr-3[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-nocov.patch"
	"${FILESDIR}/c-blosc-1.21.4-c23.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	filter-lto
	filter-flags -pipe
	distutils-r1_python_prepare_all
}

python_compile() {
	! use cpu_flags_x86_avx2 && local -x DISABLE_NUMCODECS_AVX2=1
	! use cpu_flags_x86_sse2 && local -x DISABLE_NUMCODECS_SSE2=1
	distutils-r1_python_compile
}

python_test() {
	local PY_BUILD_DIR=$(${EPYTHON} -c "import sysconfig; print('lib.' + sysconfig.get_platform() +
		'-cpython-' + sysconfig.get_python_version().replace('.', ''))") || die
	cd "${BUILD_DIR}/build${#DISTUTILS_WHEELS}/${PY_BUILD_DIR}" || die
	epytest --pyargs numcodecs
}
