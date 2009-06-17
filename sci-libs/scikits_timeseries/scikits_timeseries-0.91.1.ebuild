# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="Python classes and functions for manipulating, reporting, and
plotting time series."
HOMEPAGE="http://pytseries.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/pytseries/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/pytseries/${MY_P}-html_docs.zip )"

LICENSE="BSD eGenixPublic"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=">=dev-lang/python-2.4
	>=dev-python/setuptools-0.6_rc9"
RDEPEND=">=dev-lang/python-2.4
	>=dev-python/numpy-1.3.0
	>=sci-libs/scipy-0.7.0
	>=dev-python/matplotlib-0.98.0"

S="${WORKDIR}/${MY_P}"

