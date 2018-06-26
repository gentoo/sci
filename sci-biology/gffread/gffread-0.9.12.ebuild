# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GFF/GTF utility providing format conversions, filter/extract regions from FASTA"
HOMEPAGE="http://ccb.jhu.edu/software/stringtie/gff.shtml
	https://github.com/gpertea/gffread"
SRC_URI="https://github.com/gpertea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gpertea/gclib/archive/v0.10.2.tar.gz -> gclib-0.10.2.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/Makefile.patch )
