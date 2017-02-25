# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2

MY_PV=2006-05-21
MY_P=postagger-${MY_PV}
DESCRIPTION="Stanfords log linear POS taggers"
HOMEPAGE="http://nlp.stanford.edu/software/tagger.shtml"
SRC_URI="http://nlp.stanford.edu/software/${MY_P}.tar.gz"

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

src_prepare() {
	jar xf ${MY_P}-source.jar
	rm -v ${MY_P}.jar || die
	sed \
		-e 's/import edu.stanford.nlp.ling.IndexedFeatureLabe/\/\/\0/g' \
		-i edu/stanford/nlp/stats/Counters.java || die "sed failed"
	sed \
		-e 's/import edu.stanford.nlp.sequences.BeamBestSequenceFinder/\/\/\0/g' \
		-i edu/stanford/nlp/tagger/maxent/TestSentence.java || die "sed failed"
}

src_compile() {
	ejavac `find edu -name *.java` || die "ejavac failed"
	find edu -name '*.class' -o -name '*.properties' | \
		xargs jar cf "${S}/${PN}.jar" || die "jar failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	insinto /usr/share/${PN}/wsj3t0-18-bidirectional
	doins wsj3t0-18-bidirectional/*

	insinto /usr/share/${PN}/wsj3t0-18-left3words
	doins wsj3t0-18-left3words/*
	if use doc ; then
		java-pkg_dojavadoc javadoc
	fi
	if use source ; then
		java-pkg_dosrc edu
	fi
	java-pkg_dolauncher stanford-postagger --java_args -Xmx300m --main edu.stanford.nlp.tagger.maxent.MaxentTagger
	java-pkg_dolauncher stanford-postrainer --main edu.stanford.nlp.tagger.maxent.Train
	java-pkg_dolauncher stanford-postester --main edu.stanford.nlp.tagger.maxent.Test
}
