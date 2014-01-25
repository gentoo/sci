# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Tools for Short Read FASTA/FASTQ file processing"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit"
SRC_URI="https://github.com/agordon/fastx_toolkit/releases/download/"${PV}"/"${P}".tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/PerlIO-gzip
	dev-perl/GDGraph
	sys-apps/sed
	sci-visualization/gnuplot
	sci-biology/libgtextutils"
