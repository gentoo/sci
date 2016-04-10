# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 distutils-r1

DESCRIPTION="Lightweight VCF to DB framework for disease and population genetics"
HOMEPAGE="https://github.com/arq5x/gemini
	http://gemini.readthedocs.org/en/latest"
EGIT_REPO_URI="https://github.com/arq5x/gemini.git"

LICENSE="MIT" # see note below!
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

# GEMINI includes CADD scores (PMID: 24487276) for annotating variants.
#
# CADD scores (http://cadd.gs.washington.edu/) are Copyright 2013 University of
# Washington and Hudson-Alpha Institute for Biotechnology (all rights reserved)
# but are freely available for all academic, non-commercial applications.
# For commercial licensing information contact Jennifer McCullar
