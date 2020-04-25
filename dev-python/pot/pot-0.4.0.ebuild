# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python Optimal Transport Library"
HOMEPAGE="https://github.com/PythonOT/POT"
SRC_URI="https://github.com/PythonOT/POT/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/POT-${PV}"
