# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Sphinx SVG to PDF converter extension"
HOMEPAGE="https://github.com/missinglinkelectronics/sphinxcontrib-svg2pdfconverter"
SRC_URI="
	https://github.com/missinglinkelectronics/sphinxcontrib-svg2pdfconverter/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	|| ( gnome-base/librsvg media-gfx/cairosvg media-gfx/inkscape )
"
