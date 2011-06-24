# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit elisp

MY_PN="SFST"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Uni Stuttgart Finite State Transducer tools"
HOMEPAGE="http://www.ims.uni-stuttgart.de/projekte/gramotron/SOFTWARE/SFST.html"
SRC_URI="ftp://ftp.ims.uni-stuttgart.de/pub/corpora/${MY_PN}/${MY_P}.tar.gz
vim-syntax? ( ftp://ftp.ims.uni-stuttgart.de/pub/corpora/${MY_PN}/vim-mode.tar.gz )
emacs? ( http://www.cis.uni-muenchen.de/~wastl/emacs/sfst.el )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="emacs vim-syntax"

DEPEND="sys-libs/readline
sys-devel/bison
sys-devel/flex
sys-apps/sed"
RDEPEND="sys-libs/readline"

S="${WORKDIR}/${MY_PN}"


src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's_/usr/local_$(destdir)/usr_g' -e 's/= install/= install -D/g' \
		-e 's/^strip:/all:/g' -e 's/strip $(ALLPROGRAMS)/echo/g' \
		-e "s/^CFLAGS = -O4 \(.*\)/CFLAGS = ${CFLAGS} \1/g" \
		src/Makefile || die "sed failed"
	if use emacs ; then
		cp "${DISTDIR}/sfst.el" "${S}"
	fi
	if use vim-syntax ; then
		mv "${WORKDIR}"/INSTALL "${S}"/INSTALL-vim-syntax
		mv "${WORKDIR}"/sfst.vim "${S}"/
	fi
}

src_compile() {
	cd "${S}/src"
	emake || die "make failed"
	if use emacs ; then
		cd "${S}"
		elisp_src_compile
	fi
}

src_install() {
	cd "${S}/src"
	emake destdir="${D}" install maninstall || die "install failed"
	cd "${S}"
	dodoc README || die "doc failed"
	insinto /usr/share/doc/${PF}/
	doins doc/SFST-Manual.pdf doc/SFST-Tutorial.pdf || die "doc failed"
	insinto /usr/share/${PN}
	doins -r data/*
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins sfst.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		newins "${FILESDIR}"/ftdetect-sfst.vim sfst.vim
		dodoc INSTALL-vim-syntax
	fi
	if use emacs ; then
		elisp_src_install
	fi
}

