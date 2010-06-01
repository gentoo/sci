# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgraph/jgraph-5.12.0.4.ebuild,v 1.5 2008/05/13 21:09:16 ken69267 Exp $

JAVA_PKG_IUSE="doc source"
EAPI=2
inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Open-source graph component for Java"
SRC_URI="http://www.jgraph.com/downloads/jgraphx/archive/${PN}-${MY_PV}.zip\
		-> ${P}.zip"
HOMEPAGE="http://www.jgraph.com"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

src_prepare() {
	# don't do javadoc always
	sed -i \
		-e 's/depends="doc"/depends="compile"/' \
		build.xml || die "sed failed"
	rm -rf doc/api lib/jgraphx.jar || die
}

EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_dojar lib/${PN}.jar

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
