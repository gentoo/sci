# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ab initio- and ad hoc evidence-based (RNA-Seq, BLAST) gene/ORF predictor"
HOMEPAGE="https://sourceforge.net/projects/conradcrf"
SRC_URI="https://downloads.sourceforge.net/project/conradcrf/conradcrf/Version%201/conradSrc.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.5:*
	<virtual/jdk-1.9:*
	dev-java/commons-logging
	>=dev-java/commons-lang-2.1:*
	dev-java/colt
	dev-java/dom4j
	"
	# spring # see bug #97004
	# dev-java/LBFGS # LBFGS is a numericla library we use internally for the solver
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
	<virtual/jdk-1.9:*
	dev-java/ant-core
	>=dev-java/jfreechart-1.0.3
	>=dev-java/jcommon-1.0.6
	>=dev-java/commons-math-1.1
	"
S="${WORKDIR}"

src_prepare(){
	default
	sed -e s'#lib/conrad.jar#/usr/share/conrad/lib/conrad.jar#' -i bin/conrad.sh || die
}

src_compile(){
	cd dev || die
	ant compile || die
}

src_install() {
	dobin bin/conrad.sh
	java-pkg_dojar lib/conrad.jar
	java-pkg_dolauncher conrad --jar conrad.jar
	dodoc -r docs models samples trainingFiles
}
