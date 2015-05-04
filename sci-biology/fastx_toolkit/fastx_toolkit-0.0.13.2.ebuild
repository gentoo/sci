# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Tools for Short Read FASTA/FASTQ file processing"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit"
SRC_URI="http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-"${PV}".tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-biology/libgtextutils-0.6.1"
RDEPEND="${DEPEND}
	dev-perl/PerlIO-gzip
	dev-perl/GDGraph
	sys-apps/sed
	sci-visualization/gnuplot"

src_install(){
	emake install DESTDIR="${D}"
}

