# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="nltk_contrib nltk"

inherit distutils eutils

DESCRIPTION="Natural language processing tool collection"
HOMEPAGE="http://www.nltk.org/"
SRC_URI="http://${PN}.googlecode.com/files/${P/_rc/rc}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/numpy
	dev-python/matplotlib
	dev-python/pyyaml
	>=app-dicts/wordnet-2.0
	sci-misc/pywordnet"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P/_rc/rc}
