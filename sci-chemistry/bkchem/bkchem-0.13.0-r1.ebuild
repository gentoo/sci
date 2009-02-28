# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils eutils

DESCRIPTION="A chemical drawing program"
HOMEPAGE="http://bkchem.zirael.org/"

SRC_URI="http://bkchem.zirael.org/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="cairo"

DEPEND=">=dev-lang/python-2.4
	~sci-libs/oasa-${PV}"

RDEPEND="${DEPEND}
	cairo? ( ~sci-libs/oasa-${PV}[cairo] )"

pkg_setup() {
	distutils_python_tkinter
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-setup.patch" || die "Failed to apply ${P}-setup.patch"
	epatch "${FILESDIR}/${P}-oasa_import.patch" || die "Failed to apply ${P}-oasa_import.patch"
}

src_install() {
	# strip this path from the paths in site_config.py and bkchem script
	# we have to strip the trailing / from the $D path
	STRD=`echo "$D" | sed "s/\\\\/$//g"`

	distutils_src_install "--strip=${STRD}"

	doicon images/${PN}.png
	make_desktop_entry ${PN} BKChem ${PN}.png Education
}

