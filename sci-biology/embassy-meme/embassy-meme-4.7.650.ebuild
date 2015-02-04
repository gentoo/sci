# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EBO_DESCRIPTION="wrappers for MEME - Multiple Em for Motif Elicitation"

inherit emboss-r1

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND+=" sci-biology/meme"
