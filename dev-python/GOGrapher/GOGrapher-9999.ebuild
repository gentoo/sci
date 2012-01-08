# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*" # for some reason setup.py is called for both 2.7 and 3.1 python, disable that

inherit distutils eutils flag-o-matic subversion

DESCRIPTION="A Gene Ontology Programming Library"
HOMEPAGE="https://projects.dbbe.musc.edu/trac/GOGrapher"
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="https://projects.dbbe.musc.edu/public/GOGrapher/trunk"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE=""
SLOT="0"
IUSE=""

DEPEND="dev-python/networkx
		dev-python/pygraphviz"
RDEPEND="${DEPEND}"

