# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

MY_PN=stanford-postagger
MY_P="${MY_PN}-${PV}"
DATE="2020-11-17"

DESCRIPTION="Stanfords log linear POS taggers"
HOMEPAGE="http://nlp.stanford.edu/software/tagger.shtml"
SRC_URI="http://nlp.stanford.edu/software/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.7
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.7
	${COMMON_DEP}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}-full-${DATE}"

src_prepare() {
	mkdir -p src || die
	pushd src || die
	jar xf ../${MY_P}-sources.jar || die
	sed \
		-e 's/import edu.stanford.nlp.ling.IndexedFeatureLabe/\/\/\0/g' \
		-i edu/stanford/nlp/stats/Counters.java || die "sed failed"
	sed \
		-e 's/import edu.stanford.nlp.sequences.BeamBestSequenceFinder/\/\/\0/g' \
		-i edu/stanford/nlp/tagger/maxent/TestSentence.java || die "sed failed"
	popd || die
	rm -v ${MY_P}.jar || die
	default
}

src_install() {
	java-pkg_newjar ${MY_PN}.jar ${PN}.jar
	insinto /usr/share/${PN}/wsj3t0-18-bidirectional

	if use doc ; then
		java-pkg_dojavadoc javadoc
	fi
	if use source ; then
		java-pkg_dosrc src
	fi
	java-pkg_dolauncher stanford-postagger --java_args -Xmx300m --main edu.stanford.nlp.tagger.maxent.MaxentTagger
	java-pkg_dolauncher stanford-postrainer --main edu.stanford.nlp.tagger.maxent.Train
	java-pkg_dolauncher stanford-postester --main edu.stanford.nlp.tagger.maxent.Test
}
