# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 java-ant-2

MY_PV=2007-08-19
MY_P=${PN}-${MY_PV}

DESCRIPTION="Stanfords statistical natural language parsers"
HOMEPAGE="http://www-nlp.stanford.edu/software/"
SRC_URI="http://www-nlp.stanford.edu/software/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="${IUSE}"

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

EANT_BUILD_TARGET="compile"

src_install() {
	java-pkg_dojar stanford-parser.jar
	if use doc ; then
		java-pkg_dojavadoc javadoc
	fi
	if use source ; then
		java-pkg_dosrc src
	fi
	dodoc README.txt README_dependencies.txt cedict_readme.txt
	insinto /usr/share/${PN}
	doins *ser.gz
	java-pkg_dolauncher stanford-lexparser --java_args -Xmx200m --main edu.stanford.nlp.parser.lexparser.LexicalizedParser
	java-pkg_dolauncher stanford-lexparser-gui --java_args "-server -Xmx600m" --main edu.stanford.nlp.parser.ui.Parser
}
