# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2

MY_V="16"

DESCRIPTION="DNA sequence viewer, annotation (Artemis) and comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/artemis/v"${MY_V}"/v"${PV}"/artemis_compiled_v"${PV}".tar.gz
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/samtools
		sci-biology/BamView"
RDEPEND="${DEPEND}
		>=virtual/jre-1.6"

src_install(){
	dodoc artemis.pdf
}

# do not know what is the diffeerence between artemis_compiled_v16.0.6.tar.gz, artemis_v16.0.6.jar and sartemis_v16.0.6.jar
#   ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/v16.0.6/
