# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils java-utils-2 versionator


MY_PV="$(smartgit-6.0.6)"

DESCRIPTION="SmartGIT"
HOMEPAGE="http://www.syntevo.com/smartgit"
SRC_URI="http://www.syntevo.com/download/${PN}hg/${MY_P}.tar.gz"

SLOT="0"
LICENSE="smartgit"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

RDEPEND="virtual/jre"

S="${WORKDIR}"/smartgit-${MY_PV}

pkg_nofetch(){
	einfo "Please download ${MY_P}.tar.gz from:"
	einfo "http://www.syntevo.com/download/smartgithg/"
	einfo "and move/copy to ${DISTDIR}"
}

src_install() {
	local rdir="/opt/${PN}"
	insinto ${rdir}
	doins -r * || die "cannot install needed files"

	java-pkg_regjar "${D}"/${rdir}/lib/*.jar

	java-pkg_dolauncher ${PN} --java_args "-Xmx256M -Dsmartgit.vm-xmx=256m" --jar ${PN}.jar

	for X in 32 64 128
	do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}/bin/smartsvn-${X}.png" "${PN}.png" || die "cannot install needed files"
	done

	make_desktop_entry "${PN}" "SmartGIT" ${PN}.png "Development;RevisionControl"
}
