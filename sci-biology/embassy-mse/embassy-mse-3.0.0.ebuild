# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-mse/embassy-mse-1.0.0-r7.ebuild,v 1.2 2010/01/01 22:05:28 fauli Exp $

EBOV="6.3.1"
EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"

inherit embassy-ng

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

IUSE+=" ncurses"

EBO_ECONF="$(use_with ncurses curses ${EPREFIX}/usr)"

src_install() {
	embassy-ng_src_install
	insinto /usr/include/emboss/mse
	doins h/*.h
}
