# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for wordnet"
HOMEPAGE="http://pywordnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=app-dicts/wordnet-2.0"
RDEPEND="${DEPEND}"

DOCS=docs/*


