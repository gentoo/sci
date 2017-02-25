# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simultaneous genotype calling and haplotype phasing for unrelated individuals"
HOMEPAGE="http://faculty.washington.edu/browning/beaglecall/beaglecall.html"
SRC_URI="http://faculty.washington.edu/browning/beaglecall/beaglecall_1.0.1_15Nov10.src.zip
	http://faculty.washington.edu/browning/beaglecall/beaglecall_1.0_15Nov10.pdf
	http://faculty.washington.edu/browning/beaglecall/beaglecall_example.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.5:*"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*"

# src/ contains *.java files only
# example/
