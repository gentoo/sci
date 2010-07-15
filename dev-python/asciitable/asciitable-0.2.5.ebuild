# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="An extensible ASCII table reader"
HOMEPAGE="http://cxc.harvard.edu/contrib/asciitable/"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.gz"

IUSE="test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

RDEPEND="dev-python/numpy"
DEPEND="test? ( dev-python/numpy )"

RESTRICT_PYTHON_ABIS="3.*"
