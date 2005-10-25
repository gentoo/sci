# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kst/kst-0.97.ebuild,v 1.4 2005/08/20 17:49:49 ribosome Exp $

inherit kde

DESCRIPTION="A plotting and data viewing program for KDE"
HOMEPAGE="http://omega.astro.utoronto.ca/kst/"
SRC_URI="http://omega.astro.utoronto.ca/kst/${P}.tar.gz"

KEYWORDS="amd64 ppc ~sparc x86"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

DEPEND="kde-base/kdelibs"
need-kde 3.1
