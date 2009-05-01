# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="ZSI"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Web Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/zsi.html"
#SRC_URI="mirror://sourceforge/pywebsvcs/${MY_P}.tar.gz"
SRC_URI="http://dev.gentooexperimental/~jlec/science-dist/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="PYTHON"
IUSE="examples doc twisted"

DEPEND="!<=sci-chemistry/apbs-1.1.0
		>=dev-python/pyxml-0.8.3
		>=dev-python/setuptools-0.6_rc3
		twisted? (
			>=dev-python/twisted-2.0
			>=dev-python/twisted-web-0.5.0
			>=dev-lang/python-2.4 )"

PYTHON_MODNAME=${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if ! use twisted ; then
		sed -i \
			-e "/version_info/d"\
			-e "/ZSI.twisted/d"\
			setup.py
	fi
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml doc/*.html doc/*.css doc/*.png
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/examples/* samples/*
	fi
}

DOCS="CHANGES README"
