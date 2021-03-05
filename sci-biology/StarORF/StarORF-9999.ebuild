# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2 git-r3

DESCRIPTION="Java-based utility to show ORFs in a sequence"
HOMEPAGE="http://star.mit.edu/orf"
EGIT_REPO_URI="https://github.com/starteam/starorf_java.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	>=virtual/jdk-1.5:*
	dev-java/jreleaseinfo:0"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*"

src_prepare() {
	default
	java-pkg_jar-from --into lib jreleaseinfo
}

src_install() {
	java-pkg_dojar StarORF.jar
}
