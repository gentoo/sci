# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_ANT_TASKS="ant-antlr"
JAVA_PKG_IUSE=""

inherit java-pkg-2 java-ant-2

DESCRIPTION="Automatically generate the JNI code necessary to call C libraries"
HOMEPAGE="http://jogamp.org/gluegen/www/"
# svn export -r "{2009-05-09}" https://gluegen.dev.java.net/svn/gluegen/trunk
# gluegen --username xxx --password xxx
SRC_URI="http://dev.gentoo.org/~ali_bush/distfiles/${PN}-${PV#1_p}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.4
	dev-java/antlr:0"

DEPEND="
	>=virtual/jdk-1.4
	dev-java/ant-core:0
	dev-java/antlr:0
	dev-java/cpptasks:0"

S="${WORKDIR}/${PN}-${PV#1_p}"

java_prepare() {
	rm make/lib/{cdc_fp,cpptasks}.jar
	java-pkg_jar-from --build-only --into make/lib cpptasks
	sed -i -e 's/suncc/sunc89/g' make/${PN}-cpptasks.xml || die
	java-ant_rewrite-classpath "make/build.xml"
	sed -i -e 's/\(<target name="generate.c[^"]*" \)/\1 depends="init"/g' \
		make/build.xml || die
}

src_compile() {
	cd make || dir "Unable to enter make directory"
	local antflags="-Dantlr.jar=$(java-pkg_getjars antlr)"
	local gcp="$(java-pkg_getjars --build-only ant-core):$(java-config --tools)"

	ANT_TASKS="${WANT_ANT_TASKS}" eant ${antflags} -Dgentoo.classpath="${gcp}" all
}
src_install() {
	cd build || dir "Unable to enter build directory"

	#build copies system antlr.jar here.
	#So we just need to replace it.
	rm "${PN}-rt-natives"*.jar || die
	java-pkg_dojar *.jar
	java-pkg_doso obj/*.so

	#If we are going to install the source
	#use source && java-pkg_dosrc src
}
