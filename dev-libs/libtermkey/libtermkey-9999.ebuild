# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit bzr

DESCRIPTION="This library allows easy processing of keyboard entry from terminal-based programs."
HOMEPAGE="http://www.leonerd.org.uk/code/libtermkey/"
EBZR_REPO_URI="http://bazaar.leonerd.org.uk/c/libtermkey/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="|| ( dev-libs/unibilium sys-libs/ncurses[unicode] )"

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}
