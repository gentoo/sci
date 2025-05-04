# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="Efficiently computes derivatives of numpy code."
HOMEPAGE="
	https://github.com/HIPS/autograd
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HIPS/autograd"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/HIPS/autograd/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz" # no pypi release yet...
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/numpy-1.12[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# remove pytest-cov dep
	sed -i -e 's/"pytest-cov",//g' pyproject.toml || die
	sed -i -e "s/--cov=autograd --cov-report=xml --cov-report=term//" pyproject.toml || die
	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
