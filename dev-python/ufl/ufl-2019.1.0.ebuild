# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 eutils

DESCRIPTION="Unified Form Language for declaration of for FE discretizations"
HOMEPAGE="https://github.com/FEniCS/ufl"
SRC_URI="https://github.com/FEniCS/ufl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die "pytest failed for ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Support for evaluating Bessel functions" dev-python/scipy
}
