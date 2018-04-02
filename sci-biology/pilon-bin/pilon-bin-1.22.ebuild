# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

DESCRIPTION="Fix assembled reference using BAM-aligned reads, call SNPs"
HOMEPAGE="
	https://github.com/broadinstitute/pilon
	https://github.com/broadinstitute/pilon/wiki"
SRC_URI="https://github.com/broadinstitute/pilon/releases/download/v${PV}/pilon-${PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.7:*"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*
	>=dev-java/htsjdk-1.130"

S="${WORKDIR}"

src_install(){
	cp -p "${DISTDIR}"/pilon-${PV}.jar . || die
	java-pkg_dojar pilon-${PV}.jar
}
