# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Prokaryotic whole genome annotation pipeline"
HOMEPAGE="http://www.bioinformatics.net.au/software.prokka.shtml"
SRC_URI="http://www.vicbioinformatics.com/prokka-"${PV}".tar.gz"
# 360MB

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-process/parallel
	sci-biology/bioperl
	sci-biology/prodigal
	sci-biology/ncbi-tools++
	sci-biology/hmmer
	sci-biology/infernal
	sci-biology/exonerate
	sci-biology/barrnap"
# >=hmmer-3.1
# Aragorn
# RNAmmer
# SignalP >= 4.0
# sequin
