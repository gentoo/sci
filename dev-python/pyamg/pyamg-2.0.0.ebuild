# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A library of Algebraic Multigrid (AMG) solvers with a convenient Python interface"
HOMEPAGE="http://code.google.com/p/pyamg/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/numpy-1.2.1
	>=sci-libs/scipy-0.7.0
	>=dev-python/nose-0.10.1"
RDEPEND=""
