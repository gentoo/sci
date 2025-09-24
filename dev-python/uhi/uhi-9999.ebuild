EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1

DESCRIPTION="Universal Histogram Interface"
HOMEPAGE="https://github.com/scikit-hep/uhi"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-hep/uhi"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	>=dev-python/numpy-1.19.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/hist-2.6[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/fastjsonschema[${PYTHON_USEDEP}]
		>=dev-python/boost-histogram-1.6.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
