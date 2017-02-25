# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Unified framework for finite element assembly"
HOMEPAGE="https://bitbucket.org/fenics-project/${PN}-deprecated/"
SRC_URI="https://bitbucket.org/fenics-project/${PN}-deprecated/downloads/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
