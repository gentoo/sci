# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Gene predictor using ab initio and ad hoc evidence (RNA-Seq, BLAST) on gDNA"
HOMEPAGE="http://www.broadinstitute.org/annotation/conrad
	http://sourceforge.net/projects/conradcrf"
SRC_URI="http://www.broadinstitute.org/annotation/conrad/conradSrcV1.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=virtual/jre-1.5:*
	dev-java/commons-logging
	>=dev-java/commons-lang-2.1:*
	dev-java/colt
	dev-java/dom4j
	"
	# spring # see bug #97004
	# LBFGS
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
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
	java-pkg_dojar lib/conrad.jar
	insinto /usr/share/conrad
	dodoc -r docs models samples trainingFiles
}
