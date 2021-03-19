# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="GUI-based version of LIGPLOT"
HOMEPAGE="https://www.ebi.ac.uk/thornton-srv/software/LigPlus/"
SRC_URI="LigPlus.zip"

SLOT="0"
LICENSE="ligplot+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="virtual/jre:*"
DEPEND="app-arch/unzip"

RESTRICT="fetch"

S="${WORKDIR}/LigPlus"

QA_PREBUILT="opt/${PN}/.*"

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.ebi.ac.uk/thornton-srv/software/LigPlus/applicence.html"
	elog "download ${A}"
	elog "and save into your DISTDIR folder"
}

src_prepare() {
	default
	rm -rf lib/*{win,mac} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r lib LigPlus.jar

	make_wrapper ${PN} "java -jar \"${EPREFIX}/opt/${PN}/LigPlus.jar\""
}
