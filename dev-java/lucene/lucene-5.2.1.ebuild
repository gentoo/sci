# Copyright 1999-2022 Gentoo Authors
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
SLOT="5.2"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/ant-junit:0
	dev-java/hamcrest-core:0
	dev-java/jflex:0
	modules? (
		dev-java/ant-apache-log4j:0
		dev-java/antlr:3.5
		dev-java/asm:9
		dev-java/asm-commons:9
		dev-java/junit:4
		dev-java/jakarta-regexp:1.4
		dev-java/commons-compress:0
		dev-java/commons-collections:0
		dev-java/commons-digester:0
		dev-java/commons-logging:0
		dev-java/commons-beanutils:1.7
		dev-java/commons-codec:0
		dev-java/icu4j:70
		dev-java/log4j:0
	)"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.7"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.7"

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
		-e '/svnversion.exe/d' \
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
		java-pkg_jar-from --into analysis/icu/lib icu4j-70
		# disable morfologik, dependency does not build
		# disable uima, dependency does not build
		# disable phonetic, dependency does not exist
		sed -i \
			-e 's/morfologik,//g' \
			-e 's/,uima//g' \
			-e 's/phonetic,//g' \
			-e 's/,compile-test//g' \
			analysis/build.xml || die
		rm -r analysis/morfologik || die
		rm -r analysis/uima || die
		rm -r analysis/phonetic || die
		# do not compile all the tests just because we want the modules
		sed -i \
			-e 's/name="build-modules" depends="compile-test"/name="build-modules"/g' \
			build.xml || die
		sed -i \
			-e 's/, compile-test//g' \
			module-build.xml || die
		mkdir -p expressions/lib
		# facet requires hppc which does not compile
		sed -i \
			-e '/<ant dir="${common.dir}\/facet" target="jar-core" inheritall="false">/,+2d' \
			module-build.xml || die
		rm -r facet || die
		# requires spatial4j, which does not exist
		sed -i \
			-e '/<ant dir="${common.dir}\/spatial" target="jar-core" inheritAll="false">/,+2d' \
			module-build.xml || die
		rm -r spatial || die
		# these require modules which we have disabled
		rm -r benchmark || die
		rm -r demo || die
		# fails to build for unknown reasons
		rm -r replicator || die
	fi

	java-pkg-2_src_prepare
}

src_compile() {
	EANT_BUILD_TARGET="jar-core"

	if use modules; then
	    EANT_GENTOO_CLASSPATH+="
			ant-apache-log4j
			antlr-3.5
			asm-9
			asm-commons-9
			jakarta-regexp-1.4
			commons-compress
			commons-collections
			commons-digester
			commons-logging
			commons-beanutils-1.7
			commons-codec
			icu4j-70
			log4j
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
	local i j
	for i in $(find build -name \*-${PV}.jar); do
	    j=${i##*/}
		java-pkg_newjar $i ${j%%-${PV}.jar}.jar
	done
	if use doc; then
		dodoc -r docs
		java-pkg_dohtml -r build/docs
	fi
	if use source; then
	     java-pkg_dosrc core/src/java/org
	  	 use modules && java-pkg_dosrc */src */*/src
	fi
}
