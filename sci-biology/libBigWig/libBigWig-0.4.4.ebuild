# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library for handling bigWig files (functionally replacing Jim Kent's lib)"
HOMEPAGE="https://github.com/dpryan79/libBigWig"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dpryan79/libBigWig"
else
	SRC_URI="https://github.com/dpryan79/libBigWig/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e 's#/usr/local#$(DESTDIR)/usr#' -i Makefile || die
	sed -e "s:/lib:/$(get_libdir):" -i Makefile || die
}

src_install(){
	emake install DESTDIR="${ED}"
}
