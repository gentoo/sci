# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 subversion

DESCRIPTION="A Gene Ontology Programming Library"
HOMEPAGE="https://projects.dbbe.musc.edu/trac/GOGrapher"
ESVN_REPO_URI="https://projects.dbbe.musc.edu/public/GOGrapher/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
