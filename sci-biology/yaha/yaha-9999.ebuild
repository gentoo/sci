# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="DNA mapper for single-end reads to detect structural variants (SV)"
HOMEPAGE="https://github.com/GregoryFaust/yaha"
EGIT_REPO_URI="git://github.com/GregoryFaust/yaha.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: respect CFLAGS/CXXFLAGS
# https://github.com/GregoryFaust/yaha/issues/5

src_install(){
	dobin bin/yaha
	dodoc YAHA_User_Guide.0.1.83.pdf
	dodoc README.md
}
