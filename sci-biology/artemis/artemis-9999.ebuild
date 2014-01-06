# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="DNA sequence viewer, annotation (Artemis) and comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sanger-pathogens/Artemis"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# uses its own BamView
DEPEND="
	sci-biology/samtools
	>=virtual/jdk-1.5
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5"

# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00551.html
# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00561.html
# http://gmod.org/wiki/Artemis-Chado_Integration_Tutorial
