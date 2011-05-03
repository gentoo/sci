# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

MYPN=IDLSave
MYP="${MYPN}-${PV}"

DESCRIPTION="Python module to read IDL .sav files"
HOMEPAGE="http://idlsave.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"

DEPEND="dev-python/numpy"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYP}"

DOCS="CHANGES"
