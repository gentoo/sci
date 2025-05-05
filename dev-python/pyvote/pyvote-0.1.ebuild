# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_13 )

inherit distutils-r1

DESCRIPTION="Estimate the probability of votes changing election outcomes"
HOMEPAGE="https://github.com/TheChymera/pyvote.git"
SRC_URI="https://github.com/TheChymera/pyvote/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/mpmath[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
