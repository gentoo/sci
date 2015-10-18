# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="library to parse and evaluate symbolic expressions"

HOMEPAGE="http://www.gnu.org/software/libmatheval/"
SRC_URI="mirror://gnu/${PN}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"
