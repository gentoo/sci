# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Display read alignments in BAM files, is a part of Artemis"
HOMEPAGE="http://bamview.sourceforge.net/"
SRC_URI="http://bamview.sourceforge.net/v"${PV}"/BamView_v"${PV}".jar"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/jdk"
RDEPEND="${DEPEND}
	virtual/jre"
