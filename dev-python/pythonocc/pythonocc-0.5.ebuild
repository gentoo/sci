# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=pythonOCC
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Interface to OpenCASCADE CAD library"
HOMEPAGE="http://www.pythonocc.org"
SRC_URI="http://pythonocc.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/opencascade:*"
DEPEND="${RDEPEND}
	dev-lang/swig:0"

S="${WORKDIR}"/${P}/src
