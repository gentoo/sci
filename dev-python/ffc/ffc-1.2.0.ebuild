# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Compiler for multilinear forms by generating C or C++ code for the evaluation of a multilinear form"
HOMEPAGE="http://launchpad.net/ffc"
SRC_URI="https://launchpad.net/ffc/1.2.x/1.2.0/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
