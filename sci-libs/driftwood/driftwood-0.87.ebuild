# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="driftwood lib"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/king.php"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}-src.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="richardson"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}"/${P}-src

EANT_BUILD_TARGET="build"

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src
}
