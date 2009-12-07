# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit octave-forge

DESCRIPTION="Provides functions for creating and reading avi videos"
HOMEPAGE="http://octave.sourceforge.net/video/index.html"
SRC_URI="mirror://sourceforge/octave/${OCT_PKG}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-video/ffmpeg"
DEPEND="${DEPEND}"
