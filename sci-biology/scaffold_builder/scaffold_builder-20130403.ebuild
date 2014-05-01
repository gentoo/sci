# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

S="${WORKDIR}"

DESCRIPTION="Combine FASTA contigs from a de novo assembly into scaffolds using a reference assembly"
HOMEPAGE="http://sourceforge.net/projects/scaffold-b/"
SRC_URI="http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2.py
	http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2_help.doc
	http://downloads.sourceforge.net/project/scaffold-b/Manual_v2.1.pdf"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/python"

src_install(){
	echo "#! /usr/bin/env python" > scaffold_builder_v2.py || die
	cat "${DISTDIR}"/scaffold_builder_v2.py >> scaffold_builder_v2.py || die
	dobin scaffold_builder_v2.py
	dodoc "${DISTDIR}"/scaffold_builder_v2_help.doc
	cp "${DISTDIR}"/Manual_v2.1.pdf scaffold_builder_v2_Manual.pdf || die
	dodoc scaffold_builder_v2_Manual.pdf
}
