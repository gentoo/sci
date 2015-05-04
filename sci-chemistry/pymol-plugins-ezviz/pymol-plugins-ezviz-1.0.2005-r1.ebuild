# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/sci-chemistry/pymol-plugins-ezviz/pymol-plugins-ezviz-1.0.2005.ebuild,v 1.2 2010/04/08 18:47:57 jlec dead $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="Assistance tool for the difficult to understand user interface of PyMOL"
HOMEPAGE="http://www.rit.edu/cos/ezviz/index.html"
SRC_URI="http://www.rit.edu/cos/ezviz/EZ_Viz.zip -> ${P}.zip"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND="app-arch/unzip"

S="${WORKDIR}/EZ_Viz Folder"

src_prepare() {
	edos2unix ez-viz.py
	epatch "${FILESDIR}"/gentoo.patch
	for gif in *.GIF; do
		mv ${gif} ${gif/.GIF/.gif} || die
	done
	python_copy_sources
	preperation() {
		cd "${BUILD_DIR}" || die
		sed \
			-e "s:GENTOOPYMOL:${EPREFIX}/$(python_get_sitedir):g" \
			-i ez-viz.py || die
	}
	python_foreach_impl preperation
}

src_install() {
	installation() {
		cd "${BUILD_DIR}" || die
		python_moduleinto pmg_tk/startup/
		python_domodule *.py
		python_moduleinto pmg_tk/startup/ez-viz/
		python_domodule *.gif
	}
	python_foreach_impl installation
	python_parallel_foreach_impl python_optimize
	dodoc readme.txt
}
