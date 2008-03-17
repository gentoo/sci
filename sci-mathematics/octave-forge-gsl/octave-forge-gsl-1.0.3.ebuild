# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-2.1.73-r1.ebuild,v 1.2 2006/11/03 15:44:39 markusle Exp $

inherit octave-forge

DESCRIPTION="Octave bindings to the GNU Scientific Library"
LICENSE="GPL-2"
HOMEPAGE="http://octave.sourceforge.net/gsl/index.html"
SRC_URI="mirror://sourceforge/octave/${OCT_PKG}.tar.gz"
SLOT="0"
DEPEND="sci-libs/gsl"

IUSE=""
KEYWORDS="~amd64 ~x86"
