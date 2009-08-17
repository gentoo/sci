# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="An automated scheme for Molecular Replacement"
HOMEPAGE="http://www.ccp4.ac.uk/MrBUMP"
SRC_URI="${HOMEPAGE}/release/${P}.tar.gz"

LICENSE="ccp4"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X perl"
RDEPEND="sci-chemistry/ccp4-apps[X?]
	|| ( 	sci-biology/mafft
		sci-biology/clustalw:2
		sci-biology/probcons
		sci-biology/t-coffee )
	sci-biology/fasta
	X? ( media-gfx/graphviz )
	perl? ( dev-perl/SOAP-Lite )
	>=dev-lang/python-2.3"
DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	unpack ./"${PN}".tar.gz
}

src_install(){
	insinto "${CCP4I_TOP}"
	doins -r ccp4i/{MrBUMP-ccp4i.tar.gz,MrBUMP/{help,scripts,tasks,templates}} || \
	die "failed to install interface"

	insinto /usr/share/${PN}
	doins -r share/${PN}/{data,include} || die "failed to install mrbump data"

	dobin share/${PN}/bin/* || die "failed to install binaries"

	dodoc README.txt
	dohtml html/mrbump_doc.html
}
