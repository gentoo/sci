# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Predict low-complexity regions in putative proteins"
HOMEPAGE="http://bioinformatics.cenargen.embrapa.br/portrait/download"
SRC_URI="http://bioinformatics.cenargen.embrapa.br/portrait/download/cast-linux.tar.gz"

# in 2000 in http://bioinformatics.oxfordjournals.org/content/16/10/915
# authors stated:
#   Availability: CAST (version 1.0) executable binaries are available to academic users free
#   of charge under license. Web site entry point, server and additional material:
#   http://www.ebi.ac.uk/research/cgg/services/cast/
#
# but the license file included in cast-linux.tar.gz from 2002 contains GPL-2 license

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/cast-linux

src_install(){
	dobin cast
	dodoc README
}
