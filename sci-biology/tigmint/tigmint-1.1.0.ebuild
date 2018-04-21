# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Correct misassemblies using linked reads from 10x Genomics Chromium"
HOMEPAGE="https://github.com/bcgsc/tigmint"
SRC_URI="https://github.com/bcgsc/tigmint/archive/1.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/intervaltree
	sci-biology/pybedtools
	sci-biology/pysam
	dev-python/statistics"
RDEPEND="${DEPEND}
	sci-biology/bwa
	sci-biology/bedtools
	sci-biology/samtools:0
	sci-biology/seqtools
	dev-util/makefile2graph
	media-gfx/graphviz
	dev-vcs/git
	dev-libs/libxslt
	net-misc/curl"
# for full features also sci-biology/abyss should be installed but it addition here
# would create circular dependency
