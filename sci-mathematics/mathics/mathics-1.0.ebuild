# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A free lightweight CAS using Wolfram Language"
HOMEPAGE="https://mathics.github.io/"
SRC_URI="https://github.com/mathics/Mathics/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Mathics-${PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

RDEPEND="
	~dev-python/sympy-1.0[${PYTHON_USEDEP}]
	=dev-python/django-1.8*[${PYTHON_USEDEP}]
	>=dev-python/mpmath-0.19[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
"
DEPEND="$RDEPEND"
