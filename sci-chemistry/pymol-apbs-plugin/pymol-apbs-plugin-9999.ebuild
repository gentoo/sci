# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 subversion

MY_PV="${PV##*_p}"

DESCRIPTION="APBS plugin for pymol"
HOMEPAGE="http://sourceforge.net/projects/pymolapbsplugin/"
SRC_URI=""
ESVN_REPO_URI="https://pymolapbsplugin.svn.sourceforge.net/svnroot/pymolapbsplugin/trunk/"

SLOT="0"
LICENSE="pymol"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-chemistry/apbs
	sci-chemistry/pdb2pqr
	>sci-chemistry/pymol-1.5"
DEPEND="${RDEPEND}"

src_install() {
	sed \
		-e "s:^APBS_BINARY_LOCATION.*:APBS_BINARY_LOCATION = \"${EPREFIX}/usr/bin/apbs\":g" \
		-e "s:^APBS_PSIZE_LOCATION.*:APBS_PSIZE_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/src/\":g" \
		-e "s:^APBS_PDB2PQR_LOCATION.*:APBS_PDB2PQR_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/\":g" \
		-e "s:^TEMPORARY_FILE_DIR.*:TEMPORARY_FILE_DIR = \"./\":g" \
		-i src/apbsplugin.py > apbs_tools.py || die
	python_moduleinto pmg_tk/startup/
	python_domodule apbs_tools.py
	python_optimize
}
