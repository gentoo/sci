# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: Gromacs file syntax highlighting and some macros"
HOMEPAGE="https://github.com/HubLot/vim-gromacs"
SRC_URI=""
#EGIT_REPO_URI="git://github.com/Reinis/${PN}.git"
EGIT_REPO_URI="
	https://github.com/HubLot/${PN}.git
	git://github.com/HubLot/${PN}.git
	git://github.com/Reinis/${PN}.git"

LICENSE="GPL-3"
KEYWORDS=""
IUSE=""

VIM_PLUGIN_MESSAGES="filetype"
