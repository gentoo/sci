# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C library for handling bigWig files (functionally replacing Jim Kent's lib)"
HOMEPAGE="https://github.com/dpryan79/libBigWig"
SRC_URI="https://github.com/dpryan79/libBigWig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86" # https://github.com/dpryan79/libBigWig/issues/30
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
