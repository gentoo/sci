# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simultaneous genotype calling and haplotype phasing for unrelated individuals"
HOMEPAGE="https://faculty.washington.edu/browning/beaglecall/beaglecall.html"
SRC_URI="https://faculty.washington.edu/browning/beaglecall/beaglecall_1.0.1_15Nov10.src.zip
	https://faculty.washington.edu/browning/beaglecall/beaglecall_1.0_15Nov10.pdf
	https://faculty.washington.edu/browning/beaglecall/beaglecall_example.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.5:*
	app-arch/unzip"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*"

S="${WORKDIR}/src"
