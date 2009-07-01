# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib python eutils versionator java-utils-2

MY_PV="$(replace_version_separator 2 -v $(replace_version_separator 1 _ ${PV}))"
MY_P="${PN}${MY_PV}_pymol_plugin"

DESCRIPTION="Calculation of pathways from buried cavities to outside solvent in protein structures"
HOMEPAGE="http://loschmidt.chemi.muni.cz/caver/"
#SRC_URI="http://loschmidt.chemi.muni.cz/caver/download/caver2_0-v003_pymol_plugin.zip"
SRC_URI="${MY_P}.zip"

LICENSE="CAVER"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6
	sci-chemistry/pymol"
DEPEND="app-arch/unzip"

RESTRICT="fetch"

S="${WORKDIR}/Caver${MY_PV}"/linux_mac

pkg_nofetch() {
	einfo "Download ${MY_P}.tar.gz"
	einfo "from ${HOMEPAGE}. This requires registration."
	einfo "Place tarballs in ${DISTDIR}."
}

src_install() {
	java-pkg_dojar Caver$(replace_all_version_separators _ ${PV})/*.jar

	java-pkg_jarinto /usr/share/${PN}/lib/lib/
	java-pkg_dojar Caver$(replace_all_version_separators _ ${PV})/lib/*.jar

	sed \
		-e "s:directory/where/jar/with/plugin/is/located:/usr/share/${PN}/lib/:g" \
		-i Caver$(replace_all_version_separators _ ${PV}).py

	insinto $(python_get_sitedir)/pmg_tk/startup/
	doins Caver$(replace_all_version_separators _ ${PV}).py || die
}
