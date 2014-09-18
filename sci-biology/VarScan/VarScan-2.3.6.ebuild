# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2

DESCRIPTION="Variant detection (germline, multi-sample, somatic mut., som. cp nr alterations (CNA)), SNP calls"
HOMEPAGE="http://varscan.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/varscan/VarScan.v2.3.6.jar"

LICENSE="Non-profit-OSL-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.5
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5"
