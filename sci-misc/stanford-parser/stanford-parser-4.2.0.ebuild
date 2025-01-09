# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DATE="2020-11-17"

DESCRIPTION="Stanfords statistical natural language parsers"
HOMEPAGE="https://www-nlp.stanford.edu/software/lex-parser.html"
SRC_URI="http://www-nlp.stanford.edu/software/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.7
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.7
	${COMMON_DEP}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}-full-${DATE}"

EANT_BUILD_TARGET="compile"

src_prepare() {
	mkdir -p src || die
	pushd src || die
	jar xf ../${P}-sources.jar || die
	popd || die
	default
}

src_install() {
	java-pkg_dojar ${PN}.jar
	if use doc ; then
		java-pkg_dojavadoc javadoc
	fi
	if use source ; then
		java-pkg_dosrc src
	fi
	java-pkg_dolauncher stanford-lexparser --java_args -Xmx200m --main edu.stanford.nlp.parser.lexparser.LexicalizedParser
	java-pkg_dolauncher stanford-lexparser-gui --java_args "-server -Xmx600m" --main edu.stanford.nlp.parser.ui.Parser
}
