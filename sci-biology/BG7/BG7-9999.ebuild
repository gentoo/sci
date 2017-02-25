# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="Bacterial genome annotation system"
HOMEPAGE="http://bg7.ohnosequences.com"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/bg7/BG7"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jre-1.5:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*
	sci-biology/ncbi-tools++"
