# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit java-pkg-2 java-pkg-simple python-r1 versionator

MY_PV="$(delete_all_version_separators $(get_version_component_range 1-2))"
MY_PATCH="20120106"
MY_P="${PN}-v${MY_PV}-linux"

DESCRIPTION="Predicts both the backbone and side chain 1H, 13C and 15N chemical shifts for proteins"
HOMEPAGE="http://shiftx2.wishartlab.com/"
SRC_URI="http://shiftx2.wishartlab.com/download/${MY_P}-${MY_PATCH}.tgz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="dev-util/weka"

RDEPEND="${CDEPEND}
	dev-lang/R
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}"/${MY_P}

src_compile() {
	mkdir "${S}"/build || die
	ejavac -classpath "$(java-pkg_getjars weka)" -nowarn -d "${S}"/build $(find src/ -name "*.java")
	jar cf "${PN}.jar" -C "${S}"/build . || die
	ejavac -cp $(java-pkg_getjars weka):. -Xlint ShiftXp.java


	cd "${S}"/modules/angles || die
	emake clean
	emake CFLAGS="${CFLAGS}" GCC=$(tc-getCC) LINK="${LDFLAGS}" get_angles phipsi

}

src_install() {
	java-pkg_dolauncher ${PN} --main "ShiftXp"


	local instdir="/opt/${PN}"
	dodoc README 1UBQ.pdb
	python_parallel_foreach_impl python_doscript *py

	# modules/angles
	cd "${S}"/modules/angles || die
	dobin get_angles phipsi


	# script
	python_scriptinto ${instdir}/script
	python_parallel_foreach_impl python_doscript script/*py
	exeinto ${instdir}/script
	doexe script/*.r


	# shifty3
	insinto ${instdir}
	doins -r shifty3
	python_scriptinto ${instdir}/shifty3
	python_parallel_foreach_impl python_doscript shifty3/*py
	exeinto ${instdir}/shifty3
	doexe shifty3/xalign_x
}
