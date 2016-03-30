# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit java-pkg-2

MY_V="16"

DESCRIPTION="DNA sequence viewer, annotation (Artemis) without comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/v"${PV}"/artemis_compiled_v"${PV}".tar.gz
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/v"${PV}"/artemis_v"${PV}".jar
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/v"${PV}"/sartemis_v"${PV}".jar
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/artemis_manual_complete.pdf -> ${P}.manual.pdf
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/release_notes.txt -> ${P}.release_notes.txt
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v"${MY_V}"/art_html_build.zip -> ${P}.html_build.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

DEPEND="
	!sci-biology/artemis
	sci-biology/samtools"
RDEPEND="${DEPEND}
		>=virtual/jre-1.6"

src_unpack(){
	unzip "${DISTDIR}"/${P}.html_build.zip || die
}

src_prepare(){
	default
	cd art_html_build || die
	rm -f .DS_Store HTML.index HTML.manifest || die
}

src_install(){
	cp -p "${DISTDIR}"/artemis_v"${PV}".jar artemis.jar || die
	java-pkg_dojar artemis.jar
	cp -p "${DISTDIR}"/sartemis_v"${PV}".jar sartemis.jar || die
	java-pkg_dojar sartemis.jar
	dodoc "${DISTDIR}"/${P}.manual.pdf "${DISTDIR}"/${P}.release_notes.txt
	insinto /usr/share/doc/"${PN}"/html
	doins art_html_build/*
}

# artemis_compiled_v16.0.11.tar.gz contains compiled binaries but also java *.class files
# artemis_v16.0.11.jar and sartemis_v16.0.11.jar
#   ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/v16.0.11/

pkg_postinst(){
	einfo "For BAM file support please install sci-biology/BamView"
	einfo "You may find interesting the additional web resources:"
	einfo "http://www.webact.org/WebACT"
	einfo "http://www.hpa-bioinfotools.org.uk/pise/double_act.html"
}
