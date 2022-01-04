# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test contrib"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml contrib-build.xml"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/${PV}/${P}-src.tgz"

LICENSE="Apache-2.0"
SLOT="3.6"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/ant-junit:0
	dev-java/hamcrest-core:0
	dev-java/jflex:0
	contrib? (
		dev-java/junit:4
		dev-java/jakarta-regexp:1.4
		dev-java/commons-compress:0
		dev-java/commons-collections:0
		dev-java/commons-digester:0
		dev-java/commons-logging:0
		dev-java/commons-beanutils:1.7
		dev-java/commons-codec:0
		dev-java/icu4j:70
	)"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DOCS=(
	CHANGES.txt README.txt
	NOTICE.txt CHANGES.txt
	JRE_VERSION_MIGRATION.txt
)

# [0]: Patch so that we can compile the package against ICU 50 and above
PATCHES=(
	"${FILESDIR}"/lucene_contrib_icu4j_v50.patch
	"${FILESDIR}"/${P}-ant-1.10.patch
)

EANT_GENTOO_CLASSPATH="
	ant-core
	ant-junit
	junit-4
	hamcrest-core
	jflex
	"
EANT_EXTRA_ARGS="-Dversion=${PV} -Dfailonjavadocwarning=false"
EANT_DOC_TARGET="javadocs-core"

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
		common-build.xml || die

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

	java-pkg-2_src_prepare
}

src_compile() {
	EANT_BUILD_TARGET="jar-core"

	if use contrib; then
	    EANT_GENTOO_CLASSPATH+="
			jakarta-regexp-1.4
			commons-compress
			commons-collections
			commons-digester
			commons-logging
			commons-beanutils-1.7
			commons-codec
			icu4j-70
			"
		EANT_BUILD_TARGET+=" build-contrib"
		EANT_DOC_TARGET+=" javadocs-all"
	fi

	java-ant_rewrite-classpath common-build.xml

	default
	java-pkg-2_src_compile
}

src_test() {
	if use contrib; then
	    EANT_TEST_GENTOO_CLASSPATH+=" commons-codec ${EANT_GENTOO_CLASSPATH}"
	    EANT_TEST_TARGET+=" test-contrib"
	fi

	java-pkg-2_src_test
}

src_install() {
	einstalldocs
	java-pkg_newjar build/core/${PN}-core-${PV}.jar ${PN}-core.jar

	if use contrib; then
		local i j
		for i in $(find build/contrib -name \*-${PV}.jar); do
		    j=${i##*/}
			java-pkg_newjar $i ${j%%-${PV}.jar}.jar
		done
	fi
	if use doc; then
		dodoc -r docs
		java-pkg_dohtml -r build/docs/api
	fi
	if use source; then
	     java-pkg_dosrc core/src/java/org
	  	 use contrib && java-pkg_dosrc contrib
	fi
}
