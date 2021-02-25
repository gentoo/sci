# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="Bacterial genome annotation system"
HOMEPAGE="https://github.com/bg7/BG7"
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
