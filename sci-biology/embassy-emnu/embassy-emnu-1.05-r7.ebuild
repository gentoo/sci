# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-emnu/embassy-emnu-1.05-r6.ebuild,v 1.2 2010/01/01 21:55:20 fauli Exp $

EAPI="4"

EBO_DESCRIPTION="Simple menu of EMBOSS applications"
EBO_EXTRA_ECONF="$(use_with ncurses curses)"

inherit emboss

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"
IUSE+=" ncurses"

RDEPEND+=" ncurses? ( sys-libs/ncurses )"
