# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 java-ant-2

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="DNA sequence viewer, annotation (Artemis) and comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/sanger-pathogens/Artemis"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/artemis/v13/v"${PV}"/artemis_compiled_v"${PV}".tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# uses its own BamView
DEPEND="sci-biology/samtools
		>=virtual/jdk-1.5
		>=dev-java/sun-jdk-1.5
		dev-java/ant-core"
RDEPEND="${DEPEND}
		>=virtual/jre-1.5"

# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00551.html
# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00561.html
# http://gmod.org/wiki/Artemis-Chado_Integration_Tutorial
src_compile() {
	emake || die
	# ant compile || die

	einfo "Need to figure out where does the GeneBuilder application come from so that one could use Chado for automated gene prediction pipeline"
}
