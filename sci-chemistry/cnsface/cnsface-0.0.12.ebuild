# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="GUI for the Crystallography and NMR System"
HOMEPAGE="http://cnsface.sourceforge.net"
SRC_URI="mirror://sourceforge/project/cnsface/cnsface/Altoona/${P}-altoona.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	sci-chemistry/cns"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}-altoona

PATCHES=( "${FILESDIR}"/${PV}-binary.patch )
