# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

S="${WORKDIR}"

DESCRIPTION="Combine FASTA contigs from a de novo assembly into scaffolds using a reference assembly"
HOMEPAGE="http://sourceforge.net/projects/scaffold-b
	http://edwards.sdsu.edu/scaffold_builder"
SRC_URI="http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2.1.zip
	http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2_help.doc
	http://downloads.sourceforge.net/project/scaffold-b/Manual_v2.1.pdf"

#http://www.scfbm.org/content/8/1/23
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/mummer
	dev-lang/python"

src_install(){
	echo "#! /usr/bin/env python" > scaffold_builder.pyy || die
	cat scaffold_builder.py >> scaffold_builder.pyy || die
	mv scaffold_builder.pyy scaffold_builder.py || die
	dobin scaffold_builder.py
	dodoc "${DISTDIR}"/scaffold_builder_v2_help.doc
	cp -p "${DISTDIR}"/Manual_v2.1.pdf scaffold_builder.pdf || die
	dodoc scaffold_builder.pdf
}
