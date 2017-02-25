# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Analysis package for next-generation sequencing data and prepare for IGV display"
HOMEPAGE="http://www.vicbioinformatics.com/software.nesoni.shtml"
SRC_URI="http://www.vicbioinformatics.com/"${P}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/shrimp
	sci-biology/bowtie
	sci-biology/mummer
	sci-biology/biopython
	sci-biology/picard
	dev-lang/R"

	# sci-biology/freebayes
	# SplitsTree4 http://www.splitstree.org/
	# BioConductor (limma, edgeR, goseq)
	# seriation
	# NMF
