# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 java-pkg-2 java-ant-2

DESCRIPTION="Convert NCBI BLAST output to SAM format"
HOMEPAGE="https://github.com/AstrorEnales/BlastToSam"
EGIT_REPO_URI="https://github.com/AstrorEnales/BlastToSam.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jre-1.5:*"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
	dev-java/ant-core"

src_compile() {
	ant compile || die
}

src_install() {
	java-pkg_dojar build/jar/BlastToSam.jar
	java-pkg_dolauncher
	dodoc README.md
}
