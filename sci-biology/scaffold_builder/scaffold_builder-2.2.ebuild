# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Combine FASTA contigs from a de novo assembly into scaffolds"
HOMEPAGE="
	https://sourceforge.net/projects/scaffold-b
	https://edwards.sdsu.edu/scaffold_builder"
SRC_URI="
	https://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v${PV}.zip
	https://sourceforge.net/projects/scaffold-b/files/scaffold_builder_v2_help.doc
	https://downloads.sourceforge.net/project/scaffold-b/Manual_v2.1.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

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
