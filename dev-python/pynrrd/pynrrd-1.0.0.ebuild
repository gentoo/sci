# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Simple pure-python module for reading and writing nrrd files"
HOMEPAGE="https://github.com/mhe/pynrrd"
SRC_URI="https://github.com/mhe/pynrrd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/nptyping[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="test? ( ${RDEPEND} )"

distutils_enable_tests unittest

python_test() {
	${EPYTHON} -m unittest discover -v nrrd/tests || \
		die "unittests failed for ${EPYTHON}"
}
