# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_3 python3_4 )

inherit distutils-r1 git-r3

DESCRIPTION="Python3 script to manipulate FASTA/Q files plus API for developers"
HOMEPAGE="https://github.com/sanger-pathogens/Fastaq"
EGIT_REPO_URI="https://github.com/sanger-pathogens/Fastaq.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
