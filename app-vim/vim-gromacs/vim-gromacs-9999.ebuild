# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: Gromacs file syntax highlighting and some macros"
HOMEPAGE="https://github.com/HubLot/vim-gromacs"
#EGIT_REPO_URI="git://github.com/Reinis/${PN}.git"
EGIT_REPO_URI="
	https://github.com/HubLot/${PN}.git
	git://github.com/HubLot/${PN}.git
	git://github.com/Reinis/${PN}.git"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS=""
IUSE=""

VIM_PLUGIN_MESSAGES="filetype"
