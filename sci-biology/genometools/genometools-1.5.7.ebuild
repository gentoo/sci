# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A collection of tools for bioinformatics (notably Tallymer, Readjoiner, gff3validator)"
HOMEPAGE="http://genometools.org"
SRC_URI="http://genometools.org/pub/${P}.tar.gz"

LICENSE="ICS"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="x11-libs/pango
	x11-libs/cairo"
RDEPEND="${DEPEND}"
