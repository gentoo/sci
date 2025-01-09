# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="GUI for Velvet de novo assembler"
HOMEPAGE="https://vicbioinformatics.com/software.vague.shtml"

if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Victorian-Bioinformatics-Consortium/vague"
else
	SRC_URI="https://vicbioinformatics.com/vague-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=virtual/jre-1.5:*
	sci-biology/velvet"
DEPEND=">=virtual/jdk-1.5:*"

S="${WORKDIR}"/vague-${PV}

PATCHES=(
	"${FILESDIR}"/vague.patch
)

src_prepare(){
	default
	sed -e "s#-jar /usr/share#-jar ${EPREFIX}/usr/share#" -i vague || die
}

src_install(){
	dobin vague
	java-pkg_dojar vague.jar
}
