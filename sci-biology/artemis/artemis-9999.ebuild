# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="DNA sequence viewer/annotation (Artemis) and comparison (ACT) tool"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/artemis"
SRC_URI="
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.pdf -> ${P}.manual.pdf
	ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/art_html_build.zip -> ${P}.html_build.zip"
EGIT_REPO_URI="https://github.com/sanger-pathogens/Artemis"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# uses its own BamView
RDEPEND="
	sci-biology/samtools:0
	>=virtual/jre-1.6:*"
DEPEND="${RDEPEND}
	!sci-biology/artemis-bin
	dev-java/ant-core
	>=virtual/jdk-1.6:*
	dev-java/log4j
	dev-java/jdbc-postgresql
	dev-java/jakarta-regexp
	dev-java/batik
	dev-java/j2ssh
	sci-biology/picard
	dev-java/biojava"
# some more dependencies extracted from /usr/bin/act
# JacORB.jar, jemAlign.jar, macos.jar, chado-14-interface.jar, iBatis, biojava.jar,
#

# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00551.html
# http://www.mail-archive.com/artemis-users@sanger.ac.uk/msg00561.html
# http://gmod.org/wiki/Artemis-Chado_Integration_Tutorial

# BamView is at http://bamview.sourceforge.net/

src_unpack(){
	unzip "${DISTDIR}"/art_html_build.zip || die
}

src_compile(){
	ant || die
}

src_install(){
	dobin act act.command art dnaplotter gff2embl
	java-pkg_dojar ant-build/artemis.jar
	dodoc "${DISTDIR}"/"${P}".manual.pdf README
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
