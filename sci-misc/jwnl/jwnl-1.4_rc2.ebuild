# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_P=${PN}${PV//.}

DESCRIPTION="Java interface to WordNet dictionary data"
HOMEPAGE="https://sourceforge.net/projects/jwordnet/"
SRC_URI="https://downloads.sourceforge.net/jwordnet/${MY_P//_rc/-rc}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/commons-logging:0
	dev-java/junit:4
"
DEPEND=">=virtual/jdk-1.7
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.7
	${COMMON_DEP}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P//_rc/-rc}"

src_prepare() {
	rm jwnl.jar lib/commons-logging.jar lib/junit-4.1.jar || die
	default
}

src_compile() {
	# picked up from dev-java/ant-eclipse-ecj
	ejavac -classpath "$(java-pkg_getjars commons-logging):$(java-pkg_getjars junit:4)" \
		`find -name '*.java'` || die "ejavac failed"
	find -name '*.class' -o -name '*.properties' | \
		xargs jar cf "${S}/${PN}.jar" || die "jar failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	insinto /usr/share/${PN}
	doins -r sql config
	dodoc changes.txt
}
