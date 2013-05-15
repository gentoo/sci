# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2

DESCRIPTION="DNA sequence viewer, annotation (Artemis) and comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/artemis/v13/v"${PV}"/artemis_compiled_v"${PV}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/samtools
		sci-biology/bamview"
RDEPEND="${DEPEND}
		>=virtual/jre-1.5"
