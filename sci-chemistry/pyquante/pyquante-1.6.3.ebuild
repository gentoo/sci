# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PyQuante"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="a quantum chemistry package written in Python."
HOMEPAGE="http://pyquante.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"
