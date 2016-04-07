# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Speed up bacterial genome assemblies by artemis and compare chromosome regions"
HOMEPAGE="http://contiguator.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/contiguator/CONTIGuator_v2.7.tar.gz
	https://sourceforge.net/projects/contiguator/files/README.md"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/abacas-1.3.1
	sci-biology/primer3
	|| ( sci-biology/ncbi-tools++ sci-biology/ncbi-blast+ )
	sci-biology/biopython
	sci-biology/mummer
	|| ( sci-biology/artemis || ( sci-biology/artemis-bin sci-biology/act-bin ) )"

S="${WORKDIR}"/CONTIGuator_v"${PV}"

src_install(){
	dobin CONTIGuator.py
	dodoc Manual.pdf "${DISTDIR}"/README.md
}
