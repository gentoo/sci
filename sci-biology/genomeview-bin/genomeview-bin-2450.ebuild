# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-opt-2 java-ant-2

DESCRIPTION="Genome browser and annotation tool"
HOMEPAGE="https://genomeview.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/genomeview/GenomeView/genomeview-2450.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.7:*"
RDEPEND=">=virtual/jre-1.7:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/genomeview-${PV}"

src_install() {
	java-pkg_dojar *.jar lib/*.jar
}
