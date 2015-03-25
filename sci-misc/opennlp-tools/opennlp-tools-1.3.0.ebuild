# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Natural Language Programming API and tool suite"
HOMEPAGE="http://opennlp.sf.net/"

MODELS="
	english/chunker/EnglishChunk.bin.gz
	english/coref/acronyms
	english/coref/cmodel.bin.gz
	english/coref/cmodel.nr.bin.gz
	english/coref/defmodel.bin.gz
	english/coref/defmodel.nr.bin.gz
	english/coref/fmodel.bin.gz
	english/coref/fmodel.nr.bin.gz
	english/coref/gen.bin.gz
	english/coref/gen.fem
	english/coref/gen.mas
	english/coref/imodel.bin.gz
	english/coref/imodel.nr.bin.gz
	english/coref/num.bin.gz
	english/coref/plmodel.bin.gz
	english/coref/plmodel.nr.bin.gz
	english/coref/pmodel.bin.gz
	english/coref/pmodel.nr.bin.gz
	english/coref/pnmodel.bin.gz
	english/coref/pnmodel.nr.bin.gz
	english/coref/sim.bin.gz
	english/coref/tmodel.bin.gz
	english/coref/tmodel.nr.bin.gz
	english/namefind/date.bin.gz
	english/namefind/location.bin.gz
	english/namefind/money.bin.gz
	english/namefind/organization.bin.gz
	english/namefind/percentage.bin.gz
	english/namefind/person.bin.gz
	english/namefind/time.bin.gz
	english/parser/build.bin.gz
	english/parser/check.bin.gz
	english/parser/chunk.bin.gz
	english/parser/dict.bin.gz
	english/parser/head_rules
	english/parser/tag.bin.gz
	english/parser/tagdict
	english/sentdetect/EnglishSD.bin.gz
	english/tokenize/EnglishTok.bin.gz
	spanish/postag/SpanishPOS.bin.gz
	spanish/sentdetect/SpanishSent.bin.gz
	spanish/tokenize/SpanishTok.bin.gz
	spanish/tokenize/SpanishTokChunk.bin.gz"
for m in ${MODELS} ; do
	MODELS_SRC_URI="${MODELS_SRC_URI} http://opennlp.sourceforge.net/models/${m}"
done

SRC_URI="mirror://sourceforge/opennlp/${P}.tgz
models? ( ${MODELS_SRC_URI} )"

# Toolkit is all LGPL-2.1
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="${IUSE} models"

COMMON_DEP="
	dev-java/trove
	>=sci-misc/jwnl-1.3_rc3
	>=app-dicts/wordnet-2.0
	sci-misc/opennlp-maxent"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

EANT_BUILD_TARGET="compile package"

src_prepare() {
	# Models shan’t be unpacked!
	cd "${S}"/lib || die
	rm -v *.jar || die "failed to rm jars"
	java-pkg_jar-from trove
	java-pkg_jar-from jwnl jwnl.jar jwnl-1.3.3.jar
	java-pkg_jar-from opennlp-maxent opennlp-maxent.jar maxent-2.4.0.jar
}

src_install() {
	java-pkg_newjar output/${P}.jar
	java-pkg_dohtml docs/*html docs/*css docs/*.jpg
	if use doc ; then
		java-pkg_dojavadoc docs/api
	fi
	if use source ; then
		java-pkg_dosrc src/java/opennlp
	fi
	dodoc AUTHORS CHANGES README
	if use models ; then
		dodir /usr/share/${PN}/models/
		for m in ${MODELS} ; do
			dodir /usr/share/${PN}/models/$(dirname ${m})
			insinto /usr/share/${PN}/models/$(dirname ${m})
			doins ${m}
		done
	fi
	# convenience: from README→Running tools
	java-pkg_dolauncher opennlp-en-sd --main opennlp.tools.lang.english.SentenceDetector
	java-pkg_dolauncher opennlp-en-tokenize --main opennlp.tools.lang.english.Tokenizer
	java-pkg_dolauncher opennlp-en-postag --main opennlp.tools.lang.english.PosTagger
	java-pkg_dolauncher opennlp-en-chunk --main opennlp.tools.lang.english.TreebankChunker
	java-pkg_dolauncher opennlp-en-name-find --main opennlp.tools.lang.english.NameFinder --java_args -Xmx350m
	java-pkg_dolauncher opennlp-en-parser --main opennlp.tools.lang.english.TreebankParser --java_args -Xmx350m
	java-pkg_dolauncher opennlp-en-coreference --main opennlp.tools.lang.english.TreebankLinker --java_args -Xmx200m
	java-pkg_dolauncher opennlp-es-sd --main opennlp.tools.lang.spanish.SentenceDetector
	java-pkg_dolauncher opennlp-es-tokenize --main opennlp.tools.lang.spanish.Tokenizer
	java-pkg_dolauncher opennlp-es-chunk --main opennlp.tools.lang.spanish.TokenChunker
	java-pkg_dolauncher opennlp-es-postag --main opennlp.tools.lang.spanish.PosTagger
	java-pkg_dolauncher opennlp-sd-train --main opennlp.tools.sentdetect.SentenceDetectorME
	java-pkg_dolauncher opennlp-postag-train --main opennlp.tools.postag.POSTaggerME
	java-pkg_dolauncher opennlp-chunk-train --main opennlp.tools.chunker.ChunkerME
	java-pkg_dolauncher opennlp-namefind-train --main opennlp.tools.namefind.NameFinderME
	java-pkg_dolauncher opennlp-parser-train --main opennlp.tools.parser.ParserME
}

pkg_postinst() {
	einfo "Some convenience java launchers have been installed under"
	einfo "names of opennlp-*. These only refer to correct classes, "
	einfo "and models and additional parameters have to be supplied "
	einfo "manually. For more info read "
	einfo "  ${ROOT}/usr/share/doc/${PF}/README"
}
