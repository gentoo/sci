# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="py.test"

inherit eutils distutils git-2

DESCRIPTION="The Python Machine Learning Library"
HOMEPAGE="http://pybrain.org/"
EGIT_REPO_URI="git://github.com/pybrain/pybrain.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="sci-libs/scipy"
DEPEND="dev-python/setuptools
	test? ( ${RDEPEND} )"
