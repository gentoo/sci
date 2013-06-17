# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils java-pkg-2

DESCRIPTION="Software for molecular visualisation"
HOMEPAGE="http://openastexviewer.net/"
SRC_URI="http://openastexviewer.net/web/OpenAstexViewerSrc.zip -> ${P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

CDEPEND="
	dev-java/nanoxml
	dev-java/jlex
	~dev-java/javacup-0.10k"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	dev-java/java-config"

S="${WORKDIR}"

src_prepare() {
	rm -r \
		"${S}/lib/nanoxml.jar" \
		"${S}/lib/nanoxml/" \
		"${S}/lib/oracle/" \
		"${S}/src/java_cup" \
		"${S}/src/JLex" \
		"${S}/src/astex/thinlet/ThinletOracle.java" || die # unused java file with hardcoded oracle jdbc usage
}

src_compile() {
	local build_dir="${S}"/build
	local dist_dir="${S}"/dist
	local classpath="-classpath $(java-pkg_getjars nanoxml,javacup,jlex):${build_dir}:./lib"
	mkdir "${build_dir}" "${dist_dir}" || die

	ejavac ${classpath} -nowarn -d "${build_dir}" $(find src/ -name "*.java") || die
	cp -r \
		"${S}"/lib/jclass \
		"${S}"/src/*.properties \
		"${S}"/src/{images,fonts} "${build_dir}" || die
	cp -r "${S}"/src/astex/thinlet/*.{properties,gif} "${build_dir}"/astex/thinlet/ || die

	jar cfm "${dist_dir}/${PN}.jar" "${S}/src/AstexViewer.manifest" -C build . || die "jar failed"
}

src_install() {
	java-pkg_dojar "${S}/dist/${PN}.jar"
	java-pkg_dolauncher openastexviewer --main astex.MoleculeViewer

	newicon src/astex_logo.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}
}
