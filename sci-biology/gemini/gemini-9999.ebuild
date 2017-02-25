# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 distutils-r1

DESCRIPTION="Lightweight VCF to DB framework for disease and population genetics"
HOMEPAGE="https://github.com/arq5x/gemini
	http://gemini.readthedocs.org/en/latest"
# https://media.readthedocs.org/pdf/gemini/latest/gemini.pdf
# http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1003153
# http://quinlanlab.org/pdf/Gemini-Quinlan-Stroke-UVA.pdf
EGIT_REPO_URI="https://github.com/arq5x/gemini.git"

LICENSE="MIT" # see note below!
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="dev-python/sqlalchemy
	sci-biology/grabix
	sci-libs/htslib
	sci-biology/bedtools
	sci-biology/pybedtools
	${DEPEND}"

# GEMINI includes CADD scores (PMID: 24487276) for annotating variants.
#
# CADD scores (http://cadd.gs.washington.edu/) are Copyright 2013 University of
# Washington and Hudson-Alpha Institute for Biotechnology (all rights reserved)
# but are freely available for all academic, non-commercial applications.
# For commercial licensing information contact Jennifer McCullar
