# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2 toolchain-funcs

DESCRIPTION="Visualization and manually annotating whole genomes"
HOMEPAGE="http://www.broadinstitute.org/annotation/argo/"
SRC_URI="http://www.broadinstitute.org/annotation/argo/argo.jar"
#SRC_URI="http://www.broadinstitute.org/annotation/argo/src/workspace-2008-03-11.tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

DEPEND=""
RDEPEND="${DEPEND}
		java? ( >=virtual/jre-1.4 )"

S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}"/argo.jar argo.jar
	java-pkg_dolauncher
}
