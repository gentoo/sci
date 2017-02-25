# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2 java-utils-2 toolchain-funcs

DESCRIPTION="Production tool for visualizing and manually annotating whole genomes"
HOMEPAGE="http://www.broadinstitute.org/annotation/argo2
	http://www.broadinstitute.org/annotation/argo"
SRC_URI="http://www.broadinstitute.org/annotation/argo/src/workspace-2008-03-11.tgz"
#
# cat workspace-2008-03-11/annotation/argo/version.txt
# Gebo-1.0.17-build-1313

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	!sci-biology/argo-bin
	>=virtual/jdk-1.5:*
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5:*"

S="${WORKDIR}"/workspace-2008-03-11

src_compile(){
	cd "${S}"/annotation/argo
	ant build || die
}

src_install() {
	java-pkg_dojar annotation/dist/argo/argo.jar
	#java-pkg_dolauncher --jar argo.jar
	java-pkg_dojar annotation/dist/argo/argo-applet-unproguarded.jar
	#java-pkg_dolauncher --jar argo-applet-unproguarded.jar
}
