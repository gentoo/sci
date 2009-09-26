# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

MY_PN="${PN#pymol-plugins-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Gives Pymol additional functionalities and presets to the PyMOL GUI"
HOMEPAGE="http://bni-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.zip"

LICENSE="CNRI"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="sci-chemistry/pymol"
DEPEND="app-arch/unzip"

src_compile(){
	true
}

src_install(){
	insinto $(python_get_sitedir)/pmg_tk/startup/
	doins bni-tools.py || die "Failed to install ${P}"
	dodoc readme.txt || die "No dodoc"
}

pkg_postinst(){
	python_mod_optimize "${ROOT%/}"$(python_get_sitedir)/pmg_tk/startup/
}

pkg_postrm() {
	python_mod_cleanup "${ROOT%/}"$(python_get_sitedir)/pmg_tk/startup/
}

