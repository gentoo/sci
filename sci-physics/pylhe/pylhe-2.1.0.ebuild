# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

# export is needed here!
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

DESCRIPTION="Lightweight Python interface to read Les Houches Event (LHE) files"
HOMEPAGE="https://github.com/scikit-hep/pylhe"

LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-hep/pylhe"
else
	inherit pypi
	# pypi does not include tests
	SRC_URI="https://github.com/scikit-hep/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

RDEPEND="
	>=dev-python/awkward-2.7[${PYTHON_USEDEP}]
	>=dev-python/graphviz-0.19[${PYTHON_USEDEP}]
	>=sci-physics/particle-0.26[${PYTHON_USEDEP}]
	>=dev-python/vector-1.6.3[${PYTHON_USEDEP}]
	>=dev-python/h5py-3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=sci-physics/scikit-hep-testdata-0.6.9[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}"-2.0.0-coverage.patch
)

distutils_enable_tests pytest
