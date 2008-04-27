# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
WX_GTK_VER="2.8"
inherit eutils fortran cmake-utils wxwidgets

DESCRIPTION="Multi-language scientific plotting library"
HOMEPAGE="http://plplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ada doc +fortran fortran95 +gd gnome +java
	octave perl +python qhull +tcl +threads +tk truetype wxwindows"

RDEPEND="ada? ( virtual/gnat )
	python? ( dev-python/numpy )
	perl? ( dev-perl/PDL dev-perl/XML-DOM )
	java? ( virtual/jre )
	octave? ( sci-mathematics/octave )
	gd? ( media-libs/gd )
	gnome? ( gnome-base/libgnomeui
			 gnome-base/libgnomeprintui
			 python? ( dev-python/gnome-python ) )
	wxwindows? ( x11-libs/wxGTK:2.8 x11-libs/agg )
	tcl? ( dev-lang/tcl dev-tcltk/itcl )
	tk? ( dev-lang/tk dev-tcltk/itk )
	truetype? ( media-libs/freetype
				media-fonts/freefont-ttf
				media-libs/lasi )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	python? ( dev-lang/swig )
	java? ( virtual/jdk dev-lang/swig )
	doc? ( app-text/opensp sys-apps/texinfo )
	qhull? ( media-libs/qhull )"

DOCS="AUTHORS ChangeLog FAQ NEWS Copyright
	PROBLEMS README.release SERVICE ToDo"

pkg_setup() {

	if use gd && ! built_with_use media-libs/gd jpeg png; then
		ewarn "media-libs/gd was built without jpeg or png support"
	fi

	if use truetype && ! built_with_use media-libs/gd truetype; then
		eerror "media-libs/gd was built without truetype support"
		eerror "To build plplot with truetype, you need gd with truetype"
		die "needs gd with truetype "
	fi

	if use wxwindows && ! built_with_use x11-libs/wxGTK X; then
		eerror "You need to re-emerge wxGTK with the X flag enabled"
		die "needs wxGTk with X"
	fi

	FORTRAN="gfortran ifc g77"
	use fortran95 && FORTRAN="gfortran ifc"
	if use fortran || use fortran95; then
		fortran_pkg_setup
	fi
}

src_compile() {
	export FC=${FORTRANC}
	export F77=${FORTRANC}
	local mycmakeargs="
		$(cmake-utils_has qhull QHULL)
		$(cmake-utils_has python numpy)
		$(cmake-utils_has truetype FREETYPE)
		$(cmake-utils_has threads PTHREAD)
		$(cmake-utils_use_enable python python)
		$(cmake-utils_use_enable perl pdl)
		$(cmake-utils_use_enable doc doc)
		$(cmake-utils_use_enable tcl tcl)
		$(cmake-utils_use_enable tcl itcl)
		$(cmake-utils_use_enable tk tk)
		$(cmake-utils_use_enable tk itk)
		$(cmake-utils_use_enable java java)
		$(cmake-utils_use_enable octave octave)
		$(cmake-utils_use_enable fortran f77)
		$(cmake-utils_use_enable ada ada)
		$(cmake-utils_use_enable fortran95 f95)
		$(cmake-utils_use_enable wxwindows wxwidgets)
		$(cmake-utils_use_enable gnome gnome2)"

	use truetype && mycmakeargs="${mycmakeargs}
		-DPL_FREETYPE_FONT_PATH:PATH=/usr/share/fonts/freefont-ttf"

	use wxwindows &&  mycmakeargs="${mycmakeargs}
		-DwxWidgets_INCLUDE_DIR=/usr/include/wx${WX_GTK_VER}"

	if use python && use gnome; then
		mycmakeargs="${mycmakeargs}	-DENABLE_pygcw=ON"
	else
		mycmakeargs="${mycmakeargs}	-DENABLE_pygcw=OFF"
	fi

	cmake-utils_src_compile
}
