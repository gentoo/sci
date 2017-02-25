# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils java-pkg-2 java-utils-2 versionator

MY_P=${PN}$(delete_all_version_separators)

DESCRIPTION="Java interface to WordNet dictionary data"
HOMEPAGE="http://jwordnet.sf.net"
SRC_URI="
	mirror://sourceforge/jwordnet/${MY_P}_src.zip
	mirror://sourceforge/jwordnet/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

COMMON_DEP="dev-java/commons-logging"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}"

src_prepare() {
	rm -v commons-logging.jar jwnl.jar || die
}

src_compile() {
	# picked up from dev-java/ant-eclipse-ecj
	ejavac -classpath "$(java-pkg_getjars commons-logging)" \
		`find net -name '*.java'` || die "ejavac failed"
	find net -name '*.class' -o -name '*.properties' | \
		xargs jar cf "${S}/${PN}.jar" || die "jar failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar utilities.jar
	insinto /usr/share/${PN}
	doins create.sql database_properties.xml file_properties.xml \
		jwnl_properties.dtd jwnl_properties.xsd map_properties.xml
	dodoc changes.txt
}
