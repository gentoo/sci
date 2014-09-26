# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit java-utils-2

DESCRIPTION="Git client with support for GitHub Pull Requests+Comments, SVN and Mercurial"
HOMEPAGE="http://www.syntevo.com/smartgit"
SRC_URI="http://www.syntevo.com/download/smartgithg/smartgithg-generic-6_0_6.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

SLOT="0"
LICENSE="smartgit"
KEYWORDS="*"
IUSE=""

RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/smartgithg-${PV//./_}"

src_install() {
	insinto "/opt/${PN}"
	doins -r "${S}"/*

	java-pkg_regjar "${D}/opt/${PN}"/lib/*.jar

	java-pkg_dolauncher "${PN}" --jar "bootloader.jar"

	for i in 32 48 64 128 256
		do
			insinto "/usr/share/icons/hicolor/${i}x${i}/apps"
			newins "${S}/bin/smartgithg-${i}.png" "${PN}.png"
		done

	make_desktop_entry "${PN}" "SmartGIT" "${PN}" "Development;RevisionControl"
}
