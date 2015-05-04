# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-mse/embassy-mse-1.0.0-r7.ebuild,v 1.2 2010/01/01 22:05:28 fauli Exp $

EAPI="4"

EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"

inherit emboss

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

IUSE+=" ncurses"

RDEPEND+=" ncurses? ( sys-libs/ncurses )"

EBO_EXTRA_ECONF="$(use_with ncurses curses)"

src_install() {
	default
	insinto /usr/include/emboss/mse
	doins h/*.h
}
