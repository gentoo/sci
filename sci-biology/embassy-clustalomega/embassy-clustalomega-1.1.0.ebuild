# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EBO_DESCRIPTION="wrappers for Clustal Omega - Scalable multiple alignment of protein sequences"

inherit emboss

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+="sci-biology/clustal-omega"
