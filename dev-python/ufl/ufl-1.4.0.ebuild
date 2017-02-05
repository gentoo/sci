# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Unified Form Language for declaration of for FE discretizations"
HOMEPAGE="https://bitbucket.org/fenics-project/ufl/"
SRC_URI="https://bitbucket.org/fenics-project/ufl/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "Support for evaluating Bessel functions" sci-libs/scipy
}
