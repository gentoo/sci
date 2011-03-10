# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-emnu/embassy-emnu-1.05-r6.ebuild,v 1.2 2010/01/01 21:55:20 fauli Exp $

EBOV="6.3.1"
EBO_DESCRIPTION="EMBOSS Menu is Not UNIX - Simple menu of EMBOSS applications"
EBO_ECONF="$(use_with ncurses curses ${EPREFIX}/usr)"

inherit embassy-ng

IUSE+=" ncurses"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

RDEPEND+=" sys-libs/ncurses"
