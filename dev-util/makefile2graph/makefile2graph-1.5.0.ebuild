# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Create a graph of dependencies from GNU Make"
HOMEPAGE="https://github.com/lindenb/makefile2graph"
SRC_URI="https://github.com/lindenb/makefile2graph/archive/v1.5.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's#/usr/local#/usr#' -i Makefile || die
	default
}
