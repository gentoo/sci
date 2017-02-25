# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="Java-based utility to show ORFs in a sequence"
HOMEPAGE="http://star.mit.edu/orf"
EGIT_REPO_URI="https://github.com/starteam/starorf_java.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.5:*
	dev-java/jreleaseinfo"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*"

#src_compile() {
#	ant compile || die
#}

src_install() {
	java-pkg_dojar StarORF.jar
}
