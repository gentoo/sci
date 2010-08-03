# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN=CosmoloPy
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cosmology routines built on NumPy/SciPy"
HOMEPAGE="http://roban.github.com/CosmoloPy/ http://pypi.python.org/pypi/CosmoloPy"
SRC_URI="http://pypi.python.org/packages/source/C/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/nose
	dev-lang/swig
	doc? ( dev-python/epydoc )"
RDEPEND="sci-libs/scipy"

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	if use doc; then
		einfo "Generation of documentation"
		epydoc -n "CosmoloPy - Cosmology routines built on NumPy/SciPy" \
			--exclude='cosmolopy.EH._power' --exclude='cosmolopy.EH.power' \
			--no-private --no-frames --html --docformat restructuredtext \
			cosmolopy/ -o docAPI/ || die
		dohtml -r docAPI/*
	fi
}
