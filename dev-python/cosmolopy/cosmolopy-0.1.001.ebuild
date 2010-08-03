# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

MY_PN=CosmoloPy
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cosmology routines built on NumPy/SciPy"
HOMEPAGE="http://roban.github.com/CosmoloPy/ http://pypi.python.org/pypi/CosmoloPy"
SRC_URI="http://github.com/roban/${MY_PN}/tarball/${PV} -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
#IUSE="test"

DEPEND="dev-python/nose
	dev-lang/swig"
#  Mostly plots in matplotlib
#	test? (
#		sci-libs/scipy
#		dev-python/matplotlib
#	)"
RDEPEND="sci-libs/scipy"

RESTRICT_PYTHON_ABIS="3.*"

# http://github.com/roban/CosmoloPy/issues#issue/2
S=${WORKDIR}/roban-${MY_PN}-b9c582f

src_prepare() {
	# http://github.com/roban/CosmoloPy/issues#issue/1
	epatch "${FILESDIR}"/${P}-qa.patch
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	use doc && dohtml -r www/*
}
