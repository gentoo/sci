# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A chemical drawing program"
HOMEPAGE="http://bkchem.zirael.org/"

SRC_URI="http://bkchem.zirael.org/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="cairo"

RDEPEND=">=dev-lang/python-2.3
	cairo? ( >=dev-python/pycairo-1.2 )"

DEPEND="${RDEPEND}"

pkg_setup() {
	distutils_python_tkinter
}

src_install() {
	# strip this path from the paths in site_config.py and bkchem script
	# we have to strip the trailing / from the $D path
	STRD=`echo "$D" | sed "s/\\\\/$//g"`

	distutils_src_install "--strip=${STRD}"

	doicon images/${PN}.png
	make_desktop_entry ${PN} BKChem ${PN}.png Education
}

