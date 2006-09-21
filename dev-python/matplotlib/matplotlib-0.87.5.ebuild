# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python

DESCRIPTION="Python plotting library with Matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? http://matplotlib.sourceforge.net/users_guide_0.87.1.pdf"

# agg: use external agg library
IUSE="doc gtk tk agg"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="PYTHON"

DEPEND="virtual/python
		|| (
		>=dev-python/numpy-1.0_beta5
		dev-python/numarray
		>=dev-python/numeric-23
		)
		>=media-libs/freetype-2.1.7
		media-libs/libpng
		sys-libs/zlib
		gtk? ( >=dev-python/pygtk-2.2 )
		dev-python/pytz
		dev-python/python-dateutil
		agg? ( x11-libs/agg )"

pkg_setup() {
	if use tk; then
		python_tkinter_exists
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable autodetection, rely on USE instead
	epatch "${FILESDIR}/${PN}-0.86.2-no-autodetect.patch"

	# tkinter opens a window to determine paths. remove it by providing tcltk paths.
	sed -i \
		-e "s:/usr/local/include:/usr/include:g" \
		-e "s:/usr/local/lib:/usr/$(get_libdir)/lib:g" \
		setupext.py

	sed -i \
		-e "/^BUILD_GTK/s/'auto'/$(use gtk && echo 1 || echo 0)/g" \
		-e "/^BUILD_WX/s/'auto'/0/g" \
		-e "/^BUILD_TK/s/'auto'/$(use tk && echo 1 || echo 0)/g" \
		-e "/^BUILD_AGG/s/'auto'/$(use agg && echo 1 || echo 0)/g" \
		setup.py

}

src_install() {
	distutils_src_install

	dodoc INTERACTIVE API_CHANGES NUMARRAY_ISSUES
	if use doc ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.py examples/README
		insinto /usr/share/doc/${PF}/examples/data
		doins examples/data/*.dat
		insinto /usr/share/doc/${PF}/
		doins ${DISTDIR}/users_guide_*.pdf
	fi
}
