# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 java-pkg-2 java-ant-2

DESCRIPTION="Convert NCBI BLAST+ Pairwise/XML (-outfmt 0 or 5) output to SAM v1.4"
HOMEPAGE="https://github.com/AstrorEnales/BlastToSam"
EGIT_REPO_URI="https://github.com/AstrorEnales/BlastToSam.git"
EGIT_COMMIT="8f543ff1640b64e44701cb534e2959ff46469b2e"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5:*"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
	dev-java/ant-core
	dev-java/jython"

src_compile() {
	ant compile || die
}

src_install() {
	java-pkg_dojar build/jar/BlastToSam.jar
	java-pkg_dolauncher
	dodoc README.md
}
