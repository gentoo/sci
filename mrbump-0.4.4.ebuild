# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#CCP4=${D}

DESCRIPTION="An automated scheme for Molecular Replacement"
HOMEPAGE="http://www.ccp4.ac.uk/MrBUMP"
SRC_URI="${HOMEPAGE}/release/${P}.tar.gz"

LICENSE="ccp4"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X perl"
RDEPEND="sci-chemistrie/ccp4
	|| ( 	sci-biology/mafft
		sci-biology/clustalw_2
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

src_compile(){
	einfo "Nothing to compile"
}



src_install(){

	insinto "${CCP4I_TOP}"
	doins -r ccp4i/MrBUMP/{help,scripts,tasks,templates} || \
	die "failed to install interface"

	insinto /usr
	doins -r share || die "failed to instal mrbump data"

	fperms 755 /usr/share/mrbump/bin/{mrbump,pydbviewer}
	dosym ../usr/share/mrbump/bin/mrbump /usr/bin
	dosym ../usr/share/mrbump/bin/pydbviewer /usr/bin

	dodoc README.txt
	dohtml html/mrbump_doc.html
}
