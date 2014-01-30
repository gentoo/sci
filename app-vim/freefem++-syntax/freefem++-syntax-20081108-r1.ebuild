# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit vim-plugin

DESCRIPTION="vim plugin: syntax highlighting for freefem++ script files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1901"
# This is a workaround to make the ebuild work on an overlay:
SRC_URI="http://omploader.org/vMWlraw/freefem++-syntax-20081108.tar.gz"

LICENSE="vim"
KEYWORDS="~amd64"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for freefem++ script files."
