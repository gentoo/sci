# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Genotype calling/phasing, imputation of ungenotyped markers"
HOMEPAGE="http://faculty.washington.edu/browning/beagle/beagle.html"
SRC_URI="http://faculty.washington.edu/browning/beagle/beagle.r1399.src.zip
	http://faculty.washington.edu/browning/beagle/beagle.03Mar15.pdf
	http://faculty.washington.edu/browning/beagle/run.beagle.r1399.example -> ${PN}-example.sh
	http://faculty.washington.edu/browning/beagle/release_notes -> ${PN}-release_notes.txt"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.7:*"
RDEPEND="${DEPEND}
	sci-biology/conform-gt"
