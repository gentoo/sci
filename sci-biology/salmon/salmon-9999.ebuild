# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
SRC_URI=""
EGIT_REPO_URI="https://github.com/COMBINE-lab/salmon.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.3.2-no-boost-static.patch )

DEPEND="dev-libs/boost
		dev-libs/jemalloc"
RDEPEND="${DEPEND}"
