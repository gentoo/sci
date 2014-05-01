# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit elisp eutils

MY_PN="SFST"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Uni Stuttgart Finite State Transducer tools"
HOMEPAGE="http://www.ims.uni-stuttgart.de/projekte/gramotron/SOFTWARE/SFST.html"
SRC_URI="
	ftp://ftp.ims.uni-stuttgart.de/pub/corpora/${MY_PN}/${MY_P}.tar.gz
	vim-syntax? ( ftp://ftp.ims.uni-stuttgart.de/pub/corpora/${MY_PN}/vim-mode.tar.gz )
	emacs? ( http://www.cis.uni-muenchen.de/~wastl/emacs/sfst.el )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs vim-syntax"

DEPEND="
	sys-libs/readline
	sys-devel/bison
	sys-devel/flex
	sys-apps/sed"
RDEPEND="sys-libs/readline"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	# settings in makefile are a bit hacky
	#epatch "${FILESDIR}"/SFST-1.3-gcc43.patch || die "patch failed"
	sed \
		-e "s/^CFLAGS = -O3/CFLAGS = ${CFLAGS}/g" \
		-e "s/local//g" \
		-e 's/strip/echo strip removed: /g' \
		-e 's/# FPIC/FPIC/' \
		-e 's/ $(PREFIX/ $(DESTDIR)$(PREFIX/g' \
		-e 's/ldconfig/true/' \
		-e 's/$(INSTALL_LIBS)/$(INSTALL_DIR) $(DESTDIR)$(PREFIX)\/lib\n\t\0/' \
		-i "${S}"/src/Makefile || die "sed failed"
	cd "${S}"
	if use emacs ; then
		cp "${DISTDIR}/sfst.el" "${S}"
	fi
	if use vim-syntax ; then
		mv "${WORKDIR}"/INSTALL "${S}"/INSTALL-vim-syntax
		mv "${WORKDIR}"/sfst.vim "${S}"/
	fi
}

src_compile() {
	emake -C "${S}/src"
	if use emacs ; then
		cd "${S}"
		elisp_src_compile
	fi
}

src_install() {
	cd "${S}/src"
	# destdir works but prefix fails
	emake DESTDIR="${D}" install maninstall libinstall
	cd "${S}"
	dodoc README
	insinto /usr/share/doc/${PF}/
	doins doc/SFST-Manual.pdf doc/SFST-Tutorial.pdf
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
