# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test modules"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="https://archive.apache.org/dist/lucene/java/${PV}/${P}-src.tgz"

LICENSE="Apache-2.0"
SLOT="8.4"
KEYWORDS=""

CDEPEND="
	dev-java/ant-core:0
	dev-java/ant-junit:0
	dev-java/hamcrest-core:0
	dev-java/jflex:0
	modules? (
		dev-java/junit:4
		dev-java/jakarta-regexp:1.4
		dev-java/commons-compress:0
		dev-java/commons-collections:0
		dev-java/commons-digester:0
		dev-java/commons-logging:0
		dev-java/commons-beanutils:1.7
		dev-java/commons-codec:0
		dev-java/icu4j:56
	)"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DOCS=(
	CHANGES.txt README.txt
	NOTICE.txt CHANGES.txt
	JRE_VERSION_MIGRATION.txt
)

EANT_GENTOO_CLASSPATH="
	ant-core
	ant-junit
	junit-4
	hamcrest-core
	jflex
	"
EANT_EXTRA_ARGS="-Dversion=${PV} -Dfailonjavadocwarning=false"
EANT_DOC_TARGET="javadocs-lucene-core"

EANT_TEST_TARGET="test-core"
EANT_TEST_EXTRA_ARGS="-Dheadless=true -Djava.io.tmpdir=${T}"
EANT_TEST_GENTOO_CLASSPATH="
	ant-core
	ant-junit
	junit-4
	"
EANT_TEST_ANT_TASKS="ant-junit"

JAVA_ANT_REWRITE_CLASSPATH="yes"

# All tests in contrib/icu/test fail.
RESTRICT="test"

src_prepare() {
	default

	sed -i \
		-e '/-Xmax/ d' \
		-e '/property="ivy.available"/s,resource="${ivy.resource}",file="." type="dir",g' \
		-e '/<ivy:retrieve/d' \
		-e '/conf="${ivy.default.configuration}" sync="${ivy.sync}"/d' \
		-e '/<fail>Ivy is not available<\/fail>/d' \
		-e '/ivy:configure/d' \
		-e '/<groovy /d' \
		-e '/svnversion.exe/d' \
		-e 's/depends="ivy-availability-check,/depends="/g' \
		-e 's/ivy-availability-check,//g' \
		-e 's/resolve-groovy,//g' \
		-e 's/depends="resolve-groovy"//g' \
		-e '/<ivy:cachepath/,/\/>/d' \
		-e '/<ivy:cachepath/,/\/ivy:cachepath>/d' \
		-e '/<ivy:dependency/d' \
		-e '/<\/ivy:cachepath>/d' \
		-e '/<taskdef name="groovy"/,/\/>/d' \
		common-build.xml || die

	# do not build tests if modules enabled, we are missing a dependency
	sed -i \
		-e 's/<target name="build-modules" depends="compile-test"/<target name="build-modules"/g' \
		build.xml

	# FIXME: docs do not build if behind a proxy, -autoproxy does not work
	java-ant_xml-rewrite -f common-build.xml \
		-c -e javadoc \
		-a failonerror \
		-v "false" \
		-a additionalparam \
		-v "-Xdoclint:none"

	# There are some JS in the javadocs's bootom and in VM >= 1.8 the --allow-script-in-comments
	# is needed so docs could be built
	if java-pkg_is-vm-version-ge "1.8" ; then
		java-ant_xml-rewrite -f common-build.xml \
			-c -e javadoc \
			-a additionalparam \
			-v "-Xdoclint:none --allow-script-in-comments"
	fi

	if use modules; then
		mkdir -p analysis/icu/lib
		java-pkg_jar-from --into analysis/icu/lib icu4j-56
	fi

	java-pkg-2_src_prepare
}

src_compile() {
	EANT_BUILD_TARGET="jar-core"

	if use modules; then
	    EANT_GENTOO_CLASSPATH+="
			jakarta-regexp-1.4
			commons-compress
			commons-collections
			commons-digester
			commons-logging
			commons-beanutils-1.7
			commons-codec
			icu4j-56
			"
		EANT_BUILD_TARGET+=" build-modules"
		EANT_DOC_TARGET+=" javadocs-modules"
	fi

	java-ant_rewrite-classpath common-build.xml

	default
	java-pkg-2_src_compile
}

src_test() {
	if use modules; then
	    EANT_TEST_GENTOO_CLASSPATH+=" commons-codec ${EANT_GENTOO_CLASSPATH}"
	    EANT_TEST_TARGET+=" test-modules"
	fi

	java-pkg-2_src_test
}

src_install() {
	einstalldocs
	java-pkg_newjar build/core/${PN}-core-${PV}.jar ${PN}-core.jar

	if use modules; then
		local i j
		for i in $(find build/modules -name \*-${PV}.jar); do
		    j=${i##*/}
			java-pkg_newjar $i ${j%%-${PV}.jar}.jar
		done
	fi
	if use doc; then
		dodoc -r docs
		java-pkg_dohtml -r build/docs
	fi
	if use source; then
	     java-pkg_dosrc core/src/java/org
	  	 use modules && java-pkg_dosrc modules
	fi
}
