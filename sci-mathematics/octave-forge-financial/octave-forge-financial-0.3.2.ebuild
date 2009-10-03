# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-2.1.73-r1.ebuild,v 1.2 2006/11/03 15:44:39 markusle Exp $

inherit octave-forge

DESCRIPTION="Financial manipulation and plotting functions"
LICENSE="GPL-2"
HOMEPAGE="http://octave.sourceforge.net/financial/index.html"
SRC_URI="mirror://sourceforge/octave/${OCT_PKG}.tar.gz"
SLOT="0"

IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-mathematics/octave-forge-time-1.0.5
		>=sci-mathematics/octave-forge-miscellaneous-1.0.6"
