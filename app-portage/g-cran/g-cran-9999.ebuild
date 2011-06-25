# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils git-2

DESCRIPTION="CRAN-style packages installer helper for package managers"
HOMEPAGE="http://git.overlays.gentoo.org/gitweb/?p=proj/g-cran.git;a=summary"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/g-cran.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/R"
RDEPEND="${DEPEND}"
