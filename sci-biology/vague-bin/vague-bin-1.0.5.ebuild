# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="GUI for Velvet de novo assembler"
HOMEPAGE="http://www.vicbioinformatics.com/software.vague.shtml"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/Victorian-Bioinformatics-Consortium/vague"
	KEYWORDS=""
else
	SRC_URI="http://www.vicbioinformatics.com/vague-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=virtual/jre-1.5:*
	sci-biology/velvet
	sci-biology/velvetk"
DEPEND=">=virtual/jdk-1.5:*"

S="${WORKDIR}"/vague-${PV}

src_prepare(){
	epatch "${FILESDIR}"/vague.patch
	sed -e "s#-jar /usr/share#-jar ${EPREFIX}/usr/share#" -i vague || die
}

src_install(){
	dobin vague
	java-pkg_dojar vague.jar
}
