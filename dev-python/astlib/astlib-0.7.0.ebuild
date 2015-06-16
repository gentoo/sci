# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

MYPN=astLib
MYP=${MYPN}-${PV}

DESCRIPTION="Python astronomy modules for image and coordinate manipulation"
HOMEPAGE="http://astlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"

IUSE="doc examples"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/pyfits[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MYP}"

python_install_all() {
	use doc && dohtml docs/${MYPN}/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
