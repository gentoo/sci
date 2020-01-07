# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Manipulate arrays of complex data structures as easily as Numpy."
HOMEPAGE="https://github.com/scikit-hep/awkward-array"
SRC_URI="https://github.com/scikit-hep/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/pytest-runner"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
