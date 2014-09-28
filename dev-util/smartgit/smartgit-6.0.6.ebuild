# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils java-utils-2 versionator

MY_PV="$(replace_all_version_separators _)"
MY_P="${PN}hg-generic-${MY_PV}"

DESCRIPTION="SmartGIT"
HOMEPAGE="http://www.syntevo.com/smartgit"
SRC_URI="http://www.syntevo.com/download/${PN}hg/${MY_P}.tar.gz"

SLOT="0"
LICENSE="smartgit"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

RDEPEND=">=virtual/jre-1.7:1.7"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P/-generic/}

pkg_nofetch(){
	einfo "Please download ${A} from:"
	einfo "http://www.syntevo.com/smartgit/download"
	einfo "and move/copy to ${DISTDIR}"
}

src_install() {
	local rdir="/opt/${PN}"
	insinto ${rdir}
	doins -r *

	java-pkg_regjar "${ED}"/${rdir}/lib/*.jar

	java-pkg_dolauncher ${PN} --java_args "-Dsun.io.useCanonCaches=false -Xmx256M -Xverify:none -Dsmartgit.vm-xmx=256m" --jar bootloader.jar

	for X in 32 64 128
	do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}"/bin/smartgithg-${X}.png ${PN}.png
	done

	make_desktop_entry "${PN}" "SmartGIT" ${PN} "Development;RevisionControl"
}
