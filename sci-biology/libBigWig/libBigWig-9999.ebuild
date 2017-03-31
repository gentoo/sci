# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION="C library for handling bigWig files (functionally replacing Jim Kent's lib)"
HOMEPAGE="https://github.com/dpryan79/libBigWig"
EGIT_REPO_URI="https://github.com/dpryan79/libBigWig.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e 's#/usr/local#$(DESTDIR)/usr#' -i Makefile || die
}

src_install(){
	emake install DESTDIR="${ED}"
}
