# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/sci-chemistry/pymol-plugins-ezviz/pymol-plugins-ezviz-1.0.2005.ebuild,v 1.2 2010/04/08 18:47:57 jlec dead $

EAPI="3"

SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="assistance tool for the difficult to understand user interface of PyMOL"
HOMEPAGE="http://www.rit.edu/cos/ezviz/index.html"
SRC_URI="
	mirror://gentoo/${P}.zip
	mirror://gentoo/${P}.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
IUSE="doc"

RDEPEND="sci-chemistry/pymol"
DEPEND="
	app-arch/unzip
	${RDEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/EZ_Viz Folder"

src_prepare() {
	edos2unix ez-viz.py
	python_copy_sources
	preperation() {
		epatch "${FILESDIR}"/gentoo.patch
		sed \
			-e "s:GENTOOPYMOL:${EPREFIX}/$(python_get_sitedir):g" \
			-i ez-viz.py || die
	}
	python_execute_function -s preperation
}

src_install() {
	installation() {
		insinto $(python_get_sitedir)/pmg_tk/startup/
		doins *.py || die
		insinto $(python_get_sitedir)/pmg_tk/startup/ez-viz/
		doins *.gif || die
		for gif in *.GIF; do
			newins ${gif} ${gif/.GIF/.gif} || die
		done
	}
	python_execute_function -s installation
	dodoc readme.txt || die
}

pkg_postinst() {
	python_mod_optimize pmg_tk/startup
}

pkg_postrm() {
	python_mod_cleanup pmg_tk/startup
}
