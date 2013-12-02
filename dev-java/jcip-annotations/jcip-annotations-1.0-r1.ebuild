# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# WARNING WARNING
# Upstream source unversioned

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Annotations for Concurrency"
HOMEPAGE="http://www.jcip.net/"
SRC_URI="http://jcip.net.s3-website-us-east-1.amazonaws.com/${PN}-src.jar"

LICENSE="CC-BY-SA-2.5"
#Confirm license before entering tree.
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	mkdir -p build
	ejavac -d build $(find net -name '*.java')
	jar -cf "${PN}.jar" -C build net
}
src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc net
}
