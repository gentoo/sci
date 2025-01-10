# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="NGSEP (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home
	https://github.com/NGSEP/NGSEPcore"
SRC_URI="https://downloads.sourceforge.net/projects/ngsep/files/SourceCode/NGSEPcore_${PV}.tar.gz"

S="${WORKDIR}/${PN}_${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.8:="
DEPEND="${RDEPEND}"

src_prepare(){
	# recent versions of htsjdk now use gradle,
	# which is not supported by portage
	#rm lib/htsjdk-2.22.jar || die
	# TODO: package dev-java/jsci
	#rm lib/jsci-core.jar || die
	default
}

src_compile(){
	emake -j1
}

src_install(){
	java-pkg_dojar *.jar lib/*.jar
	einstalldocs
}
