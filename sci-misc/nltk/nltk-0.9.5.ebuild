# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="yaml nltk_contrib nltk"

inherit distutils eutils

DESCRIPTION="Natural language processing tool collection"
HOMEPAGE="http://www.nltk.org/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${PN}-data-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${DEPEND}
	dev-python/numarray
	dev-python/numpy
	dev-python/matplotlib
	>=app-dicts/wordnet-2.0
	sci-misc/pywordnet"
RDEPEND="${DEPEND}"

NLTK_DATA="${WORKDIR}/data/"

src_install() {
	distutils_src_install
	insinto /usr/share/nltk/data
	doins -r "${WORKDIR}"/${PN}_data/* || die
}
