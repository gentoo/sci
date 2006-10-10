# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python

DESCRIPTION="Python plotting library with Matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? http://matplotlib.sourceforge.net/users_guide_0.87.1.pdf"

IUSE="doc gtk tk"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="PYTHON"

DEPEND="virtual/python
	|| (
		>=dev-python/numpy-1.0_rc1
		dev-python/numarray
		>=dev-python/numeric-23
	   )
	>=media-libs/freetype-2.1.7
	media-libs/libpng
	sys-libs/zlib
	dev-python/pytz
	dev-python/python-dateutil
	media-fonts/ttf-bitstream-vera
	gtk? ( >=dev-python/pygtk-2.2 )"

pkg_setup() {
	use tk && python_tkinter_exists
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix install data path
	epatch "${FILESDIR}/${PN}-0.87.6-install-data.patch"

	# fix default paths for matplotlibrc
	epatch "${FILESDIR}/${PN}-0.87.6-matplotlibrc.patch"

	# disable autodetection, rely on USE flags
	epatch "${FILESDIR}/${PN}-0.86.2-no-autodetect.patch"
	sed -i \
		-e "/^BUILD_GTK/s/'auto'/$(use gtk && echo 1 || echo 0)/g" \
		-e "/^BUILD_WX/s/'auto'/0/g" \
		-e "/^BUILD_TK/s/'auto'/$(use tk && echo 1 || echo 0)/g" \
		setup.py


	# force tk paths to avoid opening a window
	sed -i \
		-e "s:/usr/local/include:/usr/include:g" \
		-e "s:/usr/local/lib:/usr/$(get_libdir)/lib:g" \
		setupext.py

	# svg are not execs
	chmod 644 images/*.svg

	# remove vera fonts, they are now a dependency
	rm -f fonts/ttf/Vera*.ttf
}

src_install() {
	distutils_src_install --install-data=usr/share
	insinto /etc
	doins matplotlibrc

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
