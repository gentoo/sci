# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="gff2ps can render features annotated in GFF file format into PostScript figures"
HOMEPAGE="http://genome.crg.es/software/gfftools/GFF2PS.html"
SRC_URI="ftp://genome.imim.es/pub/gff_tools/gff2ps/gff2ps_v0.98d.gz
	http://genome.imim.es/software/gfftools/gff2ps_docs/manual/MANUAL_GFF2PS_v0.96.ps.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install(){
	mv gff2ps_v0.98d gff2ps
	dobin gff2ps
	dodoc MANUAL_GFF2PS_v0.96.ps
}
