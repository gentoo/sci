# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1

DESCRIPTION="Natural language processing tool collection"
HOMEPAGE="http://www.nltk.org/"
SRC_URI="https://github.com/nltk/nltk/archive/2.0.4.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=app-dicts/wordnet-2.0
	sci-misc/pywordnet[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P/_rc/rc}
