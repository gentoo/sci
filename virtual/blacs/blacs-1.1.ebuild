# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for BLACS implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"
RDEPEND="|| (
		>=sci-libs/mpiblacs-1.1
		>=sci-libs/mkl-10.3
	)
	doc? ( >=app-doc/blacs-docs-1 )"
DEPEND=""
