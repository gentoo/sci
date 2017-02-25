# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-opt-2 java-ant-2 eutils

DESCRIPTION="Genome browser and annotation tool"
HOMEPAGE="http://genomeview.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/genomeview/GenomeView/genomeview-2450.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/jdk
	${COMMON_DEPS}"
RDEPEND="virtual/jre"

S="${WORKDIR}"/genomeview-"${PV}"
