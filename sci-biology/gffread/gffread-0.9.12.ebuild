# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GFF/GTF utility providing format conversions, filter/extract regions from FASTA"
HOMEPAGE="https://github.com/gpertea/gffread"
SRC_URI="https://github.com/gpertea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/gclib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/Makefile.patch )
