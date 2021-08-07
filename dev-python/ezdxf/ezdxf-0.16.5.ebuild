# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#FIXME: Upstream explicitly supports "pypy3", but Gentoo dependencies do not.
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python interface to DXF"
HOMEPAGE="https://pypi.org/project/ezdxf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cython matplotlib qt5"

BDEPEND="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
"
DEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
"

#FIXME: Enabling tests requires packaging additional packages (e.g., "geomdl").
RESTRICT="test"
