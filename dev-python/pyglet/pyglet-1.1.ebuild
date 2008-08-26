# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A cross-platform windowing and multimedia library in pure Python."
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="http://pyglet.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg doc examples"

RDEPEND="virtual/opengl
	|| ( dev-python/ctypes >=dev-lang/python-2.5 )
	ffmpeg? ( media-libs/avbin-bin )"

src_install() {
	DOCS="NOTICE"
	distutils_src_install

	use doc && dohtml -A txt,py -r doc/html/*
	
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
