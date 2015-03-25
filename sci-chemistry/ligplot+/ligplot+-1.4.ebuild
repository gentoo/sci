# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2

DESCRIPTION="GUI-based version of LIGPLOT"
HOMEPAGE="http://www.ebi.ac.uk/thornton-srv/software/LigPlus/"
SRC_URI="LigPlus.zip"

SLOT="0"
LICENSE="ligplot+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/jre"
DEPEND=""

RESTRICT="fetch"

S="${WORKDIR}"/LigPlus

QA_PREBUILT="opt/${PN}/.*"

pkg_nofetch() {
	einfo "Please visit"
	einfo "http://www.ebi.ac.uk/thornton-srv/software/LigPlus/applicence.html"
	einfo "download ${A}"
	einfo "and save in ${DISTDIR}"
}

src_prepare() {
	rm -rf lib/*{win,mac} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r lib LigPlus.jar

	make_wrapper ${PN} "java -jar \"${EPREFIX}/opt/${PN}/LigPlus.jar\""
}
