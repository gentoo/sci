# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="GUI for the Crystallography and NMR System"
HOMEPAGE="http://cnsface.sourceforge.net"
SRC_URI="mirror://sourceforge/${P}-altoona.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-python/wxpython:2.8
	sci-chemistry/cns"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}-altoona

src_prepare() {
	epatch "${FILESDIR}"/${PV}-binary.patch
	distutils_src_prepare
}
