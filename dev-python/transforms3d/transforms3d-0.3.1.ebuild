# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Functions for 3D coordinate transformations"
HOMEPAGE="https://matthew-brett.github.io/transforms3d"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

BDEPEND="test? ( dev-python/numpy[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/numpy-1.5.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

distutils_enable_tests nose
