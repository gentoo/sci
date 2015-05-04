# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit java-pkg-2 java-pkg-simple prefix python-r1 versionator

MY_PV="$(delete_all_version_separators $(get_version_component_range 1-2))"
MY_PATCH="20120106"
MY_P="${PN}-v${MY_PV}-linux"

DESCRIPTION="Predicts both the backbone and side chain 1H, 13C and 15N chemical shifts for proteins"
HOMEPAGE="http://shiftx2.wishartlab.com/"
SRC_URI="http://shiftx2.wishartlab.com/download/${MY_P}-${MY_PATCH}.tgz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

CDEPEND="dev-util/weka"

RDEPEND="${CDEPEND}
	dev-lang/R
	sci-biology/ncbi-tools
	sci-chemistry/reduce
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}"/${MY_P}

QA_PREBUILT="/opt/.*"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-java.patch \
		"${FILESDIR}"/${P}-system.patch

	rm "${S}"/src/FeatureRanges.java || die

	shared=$(echo "${EPREFIX}/usr/share/${PN}" | sed -e 's/\//\\\//g')
	sed -i -e "s/PUT_GENTOO_SHARE_PATH_HERE/${shared}/g" "${S}/src/ShiftXp.java" || die

	if use debug; then
		sed -i -e 's/DEBUG = false/DEBUG = true/g' "${S}/src/ShiftXp.java" || die
	fi

	# hack alert!
	sed \
		-e '/-o/s:$(GCC):$(GCC) $(LDFLAGS):g' \
		-e '/-o/s:$(CC):$(CC) $(LDFLAGS):g' \
		-i modules/*/Makefile || die

	sed -e '/-o/s:$: -lm:g' -i "${S}/modules/resmf/Makefile" || die

	eprefixify ${PN}.py
}

src_compile() {
	mkdir "${S}"/build || die
	ejavac -classpath "$(java-pkg_getjars weka)" -nowarn \
		-d "${S}"/build $(find src/ -name "*.java")
	jar cf "${PN}.jar" -C "${S}"/build . || die

	einfo "Building module angles"
	cd "${S}"/modules/angles || die
	emake clean
	emake CFLAGS="${CFLAGS}" GCC=$(tc-getCC) LINK="${LDFLAGS}" get_angles phipsi

	einfo "Building module resmf"
	cd "${S}"/modules/resmf || die
	emake clean
	emake CFLAGS="${CFLAGS}" GCC=$(tc-getCC) LINK="${LDFLAGS}" resmf

	einfo "Building module effects"
	cd "${S}"/modules/effects || die
	emake clean
	emake CFLAGS="${CFLAGS}" CC=$(tc-getCC) LINK="${LDFLAGS}" all
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dolauncher j${PN} --main "ShiftXp" --pkg_args "-dir ${EPREFIX}/usr/bin"

	insinto /usr/share/${PN}
	doins "${S}"/lib/{limitedcshift.dat,RandomCoil.csv,data-header.arff}
	doins -r "${S}"/lib/predmodels

	insinto /usr/share/${PN}/vader
	doins -r "${S}"/modules/resmf/lib/*

	local instdir="/opt/${PN}"
	dodoc README 1UBQ.pdb
	python_parallel_foreach_impl python_newscript ${PN}.py ${PN}
	mv shiftx2_util.py shiftx2util.py || die
	python_moduleinto ${PN}
	touch __init__.py
	python_parallel_foreach_impl python_domodule natsorted.py shiftx2util.py __init__.py

	# other modules
	dobin \
		"${S}"/modules/angles/{get_angles,phipsi} \
		"${S}"/modules/resmf/resmf \
		"${S}"/modules/effects/caleffect

	# script
	python_parallel_foreach_impl python_doscript "${S}"/script/*py
	exeinto ${instdir}/script
	doexe "${S}"/script/*.r

	# shifty3
	python_parallel_foreach_impl python_newscript "${S}"/shifty3/*py shifty3
	exeinto ${instdir}/shifty3
	doexe "${S}"/shifty3/xalign_x
	dosym ../${PN}/shifty3/xalign_x /opt/bin/xalign_x

	insinto ${instdir}/shifty3
	doins -r "${S}"/shifty3/{blastdb,refdb,xalign.parms,wt.rbo}

	python_parallel_foreach_impl python_doscript "${S}"/shifty3/utils/*py
	dobin "${S}"/shifty3/utils/create_blastdb.sh
}
