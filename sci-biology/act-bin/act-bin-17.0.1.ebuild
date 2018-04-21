# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

DESCRIPTION="DNA contig sequence comparison tool supplementing Artemis"
HOMEPAGE="http://www.sanger.ac.uk/science/tools/artemis-comparison-tool-act"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/act/v17/v${PV}/sact-v${PV}.jar
	ftp://ftp.sanger.ac.uk/pub/resources/software/act/v17/v${PV}/act-v${PV}.jar
	ftp://ftp.sanger.ac.uk/pub/resources/software/act/v13/act_manual_complete.pdf -> ${P}.manual.pdf
	ftp://ftp.sanger.ac.uk/pub/resources/software/act/v13/act_html_build.zip -> ${P}.html_build.zip
	ftp://ftp.sanger.ac.uk/pub/resources/software/act/v17/v${PV}/release_notes.txt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	!sci-biology/artemis"
RDEPEND="${DEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}"

src_unpack(){
	unzip "${DISTDIR}"/${P}.html_build.zip || die
}

src_prepare(){
	default
	cd act_html_build || die
	rm -f .DS_Store HTML.index HTML.manifest || die
}

src_install(){
	java-pkg_dojar "${DISTDIR}"/*.jar
	dodoc "${DISTDIR}"/${P}.manual.pdf "${DISTDIR}"/release_notes.txt
	insinto /usr/share/doc/"${PN}"/html
	doins act_html_build/*
}

pkg_postinst(){
	einfo "For BAM file support please install sci-biology/BamView"
	einfo "You may find interesting the additional web resources:"
	einfo "http://www.webact.org/WebACT"
	einfo "http://www.hpa-bioinfotools.org.uk/pise/double_act.html"
}
