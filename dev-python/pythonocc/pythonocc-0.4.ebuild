# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils

MY_PN=pythonOCC
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python Interface to OpenCASCADE CAD library"
HOMEPAGE="http://www.pythonocc.org"
SRC_URI="http://download.gna.org/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/opencascade"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${MY_P}/src
