# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ab initio- and ad hoc evidence-based (RNA-Seq, BLAST) gene/ORF predictor"
HOMEPAGE="http://www.broadinstitute.org/annotation/conrad
	http://sourceforge.net/projects/conradcrf"
SRC_URI="http://www.broadinstitute.org/annotation/conrad/conradSrcV1.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

# upstream binaries do not work with oracle-java-8
RDEPEND="
	>=virtual/jre-1.5:*
	<=virtual/jre-1.7:*
	dev-java/commons-logging
	>=dev-java/commons-lang-2.1:*
	dev-java/colt
	dev-java/dom4j
	"
	# spring # see bug #97004
	# dev-java/LBFGS # LBFGS is a numericla library we use internally for the solver
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
	<=virtual/jdk-1.7:*
	dev-java/ant-core
	>=dev-java/jfreechart-1.0.3
	>=dev-java/jcommon-1.0.6
	>=dev-java/commons-math-1.1
	"
S="${WORKDIR}"

src_prepare(){
	sed -e s'#lib/conrad.jar#/usr/share/conrad/lib/conrad.jar#' -i bin/conrad.sh || die
}

src_compile(){
	cd dev || die
	ant compile || die
}

src_install() {
	dobin bin/conrad.sh
	java-pkg_newjar lib/conrad.jar
	java-pkg_dojar lib/conrad.jar
	java-pkg_dolauncher conrad --jar conrad.jar
	insinto /usr/share/conrad
	dodoc -r docs models samples trainingFiles
}
