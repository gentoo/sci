# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Next-generation file format (NGFF) for storing bioimaging data in the cloud"
HOMEPAGE="https://github.com/con/nwb2bids"
SRC_URI="https://github.com/con/nwb2bids/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	test? (
		dev-python/pynwb[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
