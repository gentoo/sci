# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="http://pyglet.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa doc examples ffmpeg gtk +openal"

RDEPEND="
	virtual/opengl
	alsa? ( media-libs/alsa-lib[alisp] )
	ffmpeg? ( media-libs/avbin-bin )
	gtk? ( x11-libs/gtk+:2 )
	openal? ( media-libs/openal )"
DEPEND="${REDEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

src_install() {
	DOCS="NOTICE"
	distutils_src_install
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins -r doc/html || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
