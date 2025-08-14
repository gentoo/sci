# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-opt-2

DESCRIPTION="Genome browser and annotation tool"
HOMEPAGE="https://genomeview.sourceforge.net"

MY_PN="${PN%-bin}"
SRC_URI="https://downloads.sourceforge.net/project/${MY_PN}/GenomeView/${MY_PN}-${PV}.zip"
S="${WORKDIR}/genomeview-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.7:*"
RDEPEND=">=virtual/jre-1.7:*"
BDEPEND="app-arch/unzip"

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	java-pkg_dojar ./*.jar lib/*.jar
}
