# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Synteny Mapping and Analysis Program"
HOMEPAGE="http://www.agcol.arizona.edu/software/symap/ https://github.com/csoderlund/SyMAP"
SRC_URI="https://github.com/csoderlund/SyMAP/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# error: package netscape.javascript does not exist
KEYWORDS=""

DEPEND="
	sci-biology/blat
	sci-biology/mummer
	sci-biology/muscle"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}/SyMAP-${PV}/java"

src_unpack() {
	default
	cd "${S}"
	tar xvf classes_ext.tar.gz
	cd ../
	tar xvf ext.tar.gz
}

src_prepare() {
	default
	sed -e 's/#JAVA_PATH=\/usr/JAVA_PATH=\/usr/g' -i Makefile || die
}

src_compile() {
	emake class_dirs
	emake
}
