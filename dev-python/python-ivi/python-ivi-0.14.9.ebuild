# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python-based interpretation of the Interchangeable Virtual Instrument standard"
HOMEPAGE="https://github.com/python-ivi/python-ivi"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	|| (
		dev-python/python-vxi11[${PYTHON_USEDEP}]
		sci-libs/linux-gpib
	)
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
