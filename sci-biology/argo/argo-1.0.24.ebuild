# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/consed/consed-19-r2.ebuild,v 1.2 2010/10/10 21:20:04 ulm Exp $

EAPI=3

inherit java-pkg-2 java-ant-2 java-utils-2 toolchain-funcs

DESCRIPTION="Production tool for visualizing and manually annotating whole genomes"
HOMEPAGE="http://www.broadinstitute.org/annotation/argo/"
SRC_URI="http://www.broadinstitute.org/annotation/argo/src/workspace-2008-03-11.tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	dev-java/ant-core"

S="${WORKDIR}"/workspace-2008-03-11

src_compile(){
	cd "${S}"/annotation/argo
	ant build || die
}

src_install() {
	java-pkg_dojar annotation/dist/argo/argo.jar
	java-pkg_dojar annotation/dist/argo/argo-applet-unproguarded.jar
}
