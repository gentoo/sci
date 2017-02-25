# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Combine FASTA contigs from a de novo assembly into scaffolds"
HOMEPAGE="
	http://sourceforge.net/projects/scaffold-b
	http://edwards.sdsu.edu/scaffold_builder"
SRC_URI="
	http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2.1.zip
	http://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2_help.doc
	http://downloads.sourceforge.net/project/scaffold-b/Manual_v2.1.pdf"

#http://www.scfbm.org/content/8/1/23
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-biology/mummer"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install(){
	echo "#! /usr/bin/env python" > scaffold_builder.pyy || die
	cat scaffold_builder.py >> scaffold_builder.pyy || die
	mv scaffold_builder.pyy scaffold_builder.py || die
	python_foreach_impl python_doscript scaffold_builder.py
	dodoc "${DISTDIR}"/scaffold_builder_v2_help.doc
	newdoc "${DISTDIR}"/Manual_v2.1.pdf scaffold_builder.pdf
}
