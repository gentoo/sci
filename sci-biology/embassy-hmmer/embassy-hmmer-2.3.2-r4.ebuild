# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-hmmer/embassy-hmmer-2.3.2-r3.ebuild,v 1.2 2010/01/01 22:00:05 fauli Exp $

EAPI="4"

EBO_DESCRIPTION="wrappers for HMMER - Biological sequence analysis with profile HMMs"

inherit emboss

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+=" ~sci-biology/hmmer-${PV}"
