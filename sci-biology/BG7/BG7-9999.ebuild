# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2 eutils

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="A standalone bacterial genome annotation system using blastn from ncbi-tools++ for gene prediction"
HOMEPAGE="http://bg7.ohnosequences.com"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/bg7/BG7"


LICENSE="AGPL-v3"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.5
		dev-java/ant-core"
RDEPEND="${DEPEND}
		>=virtual/jre-1.5
		sci-biology/ncbi-tools++"

