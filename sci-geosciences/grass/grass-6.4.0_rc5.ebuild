# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/grass/grass-6.3.0.ebuild,v 1.7 2009/06/08 04:51:04 nerdboy Exp $

inherit eutils distutils fdo-mime versionator wxwidgets flag-o-matic

MY_PV=$(get_version_component_range 1-2 ${PV})
MY_PVM=$(delete_all_version_separators ${MY_PV})
MY_PM=${PN}${MY_PVM}

DESCRIPTION="An open-source GIS with raster and vector functionality, as well as 3D vizualization."
HOMEPAGE="http://grass.osgeo.org//"
SRC_URI="http://download.osgeo.org/grass/${MY_PM}/source/${P/_rc/RC}.tar.gz"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="ffmpeg fftw gmath jpeg largefile motif mysql nls odbc opengl png \
postgres python readline sqlite tiff truetype wxwindows X"

RESTRICT="strip"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-libs/ncurses-5.3
	>=sys-libs/gdbm-1.8.0
	|| (
	    sys-apps/man
	    sys-apps/man-db )
	sci-libs/gdal
	>=sci-libs/proj-4.4.7
	ffmpeg? ( media-video/ffmpeg )
	fftw? ( sci-libs/fftw )
	gmath? ( virtual/blas
	    virtual/lapack )
	jpeg? ( media-libs/jpeg )
	mysql? ( dev-db/mysql )
	odbc? ( >=dev-db/unixODBC-2.0.6 )
	opengl? ( virtual/opengl )
	motif? ( x11-libs/openmotif )
	png? ( >=media-libs/libpng-1.2.2 )
	postgres? ( >=dev-db/postgresql-base-8.3 )
	python? ( dev-lang/python )
	readline? ( sys-libs/readline )
	sqlite? ( dev-db/sqlite )
	tiff? ( >=media-libs/tiff-3.5.7 )
	truetype? ( >=media-libs/freetype-2.0 )
	wxwindows? (
		>=dev-python/wxpython-2.8.1.1
		>=dev-lang/python-2.4
	)
	X? (
		x11-libs/libXmu
		x11-libs/libXext
		x11-libs/libXp
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXpm
		x11-libs/libXaw
		>=dev-lang/tcl-8.4
		>=dev-lang/tk-8.4
	)"

DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.4a
	>=sys-devel/bison-1.35
	wxwindows? ( >=dev-lang/swig-1.3.31 )
	X? (
		x11-proto/xproto
		x11-proto/xextproto
	)"

pkg_setup() {
	local myblas
	elog ""
	elog "This version enables the experimental wxpython interface, which"
	elog "you may want to try.  If the legacy GUI seems a little wonky in"
	elog "this version, just enable the wxwindows USE flag and rebuild"
	elog "grass to use it."
	elog ""
	if use gmath; then
		for d in $(eselect lapack show); do myblas=${d}; done
		if [[ -z "${myblas/reference/}" ]] && [[ -z "${myblas/atlas/}" ]]; then
			ewarn "You need to set lapack to atlas or reference. Do:"
			ewarn "   eselect lapack set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
		for d in $(eselect blas show); do myblas=${d}; done
		if [[ -z "${myblas/reference/}" ]] && [[ -z "${myblas/atlas/}" ]]; then
			ewarn "You need to set blas to atlas or reference. Do:"
			ewarn "   eselect blas set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
	fi

	if use opengl && ! use X; then
		ewarn "GRASS OpenGL support needs X (will also pull in Tcl/Tk)."
		die "Please set the X useflag."
	fi
}

S=${WORKDIR}/${P/_rc/RC}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch rpm/fedora/grass-readline.patch
	# fix the fortify_source and buffer issues (see bug #261283)
	#epatch "${FILESDIR}"/${P}-o_creat.patch
	# and update for gcc 4.4 C++ changes (see bug #270916)
	#epatch "${FILESDIR}"/${P}-gcc44.patch

	sed -i -e "s:buff\[12:buff\[16:g" general/g.parser/main.c \
	    || die "sed failed"

	if ! use opengl; then
	    epatch "${FILESDIR}"/${P}-html-nonviz.patch
	fi

	# patch missing math functions (yes, this is still needed)
	sed -i -e "s:\$(EXTRA_LIBS):\$(EXTRA_LIBS) \$(MATHLIB):g" include/Make/Shlib.make
	echo "MATHLIB=-lm" >> include/Make/Rules.make
}

src_compile() {
	local myconf
	# wxwindows needs python (see bug #237495)
	use wxwindows && distutils_python_version

	myconf="--prefix=/usr --with-cxx --enable-shared \
		--with-gdal=$(type -P gdal-config) --with-curses --with-proj \
		--with-includes=/usr/include --with-libs=/usr/$(get_libdir) \
		--with-proj-includes=/usr/include \
		--with-proj-libs=/usr/$(get_libdir) \
		--with-proj-share=/usr/share/proj \
		--without-glw"

	if use X; then
	    if has_version ">=dev-lang/tcl-8.5"; then
		TCL_LIBDIR="/usr/$(get_libdir)/tcl8.5"
	    else
		TCL_LIBDIR="/usr/$(get_libdir)/tcl8.4"
	    fi
	    myconf="${myconf} --with-tcltk --with-x \
	        --with-tcltk-includes=/usr/include \
		--with-tcltk-libs=${TCL_LIBDIR}"
	    if use wxwindows; then
		WX_GTK_VER=2.8
		need-wxwidgets unicode
		# The following lib should be there, based on the above and the
		# wxpython dependency (in theory).  I still need a good way to
		# query for the location...
		LIBGDI="/usr/$(get_libdir)/python${PYVER}/site-packages/wx-${WX_GTK_VER}-gtk2-unicode/wx/_gdi_.so"
		myconf="${myconf} --with-python --with-wxwidgets=${WX_CONFIG}"
	    else
		# USE=python must be enabled above if wxwindows is enabled
		myconf="${myconf} $(use_with python) --without-wxwidgets"
	    fi
	else
		myconf="${myconf} --without-tcltk --without-x"
	fi

	if use opengl; then
	    myconf="${myconf} --with-opengl --with-opengl-libs=/usr/$(get_libdir)/opengl/xorg-x11/lib"
	else
	    myconf="${myconf} --without-opengl"
	fi

	# Should handle either older or latest without intervention;
	# this won't work forever, but it should be okay for a while...
	if use ffmpeg; then
	    myconf="${myconf} --with-ffmpeg \
	        --with-ffmpeg-libs=/usr/$(get_libdir)"
	    if has_version ">=media-video/ffmpeg-0.4.9_p20080326" ; then
		# must pass multiple include dirs now; we need to pass different include dirs so we use append-cppflags here.
		append-cppflags -I/usr/include/libswscale \
				-I/usr/include/libavcodec \
				-I/usr/include/libavdevice \
				-I/usr/include/libavfilter \
				-I/usr/include/libavformat \
				-I/usr/include/libavutil
	        #myconf="${myconf} --with-ffmpeg-includes=/usr/include/libav*"
	    else
		myconf="${myconf} --with-ffmpeg-includes=/usr/include/ffmpeg"
	    fi
	else
		myconf="${myconf} --without-ffmpeg"
	fi

	if use truetype; then
		myconf="${myconf} --with-freetype \
		    --with-freetype-includes=/usr/include/freetype2"
	fi

	if use mysql; then
		myconf="${myconf} --with-mysql --with-mysql-includes=/usr/include/mysql \
		    --with-mysql-libs=/usr/$(get_libdir)/mysql"
	else
		myconf="${myconf} --without-mysql"
	fi

	if use sqlite; then
		myconf="${myconf} --with-sqlite --with-sqlite-includes=/usr/include \
		    --with-sqlite-libs=/usr/$(get_libdir)"
	else
		myconf="${myconf} --without-sqlite"
	fi

	econf ${myconf} --with-libs=/usr/$(get_libdir) \
		$(use_enable amd64 64bit) \
		$(use_with fftw) \
		$(use_with gmath blas) \
		$(use_with gmath lapack) \
		$(use_with jpeg) \
		$(use_enable largefile) \
		$(use_with motif) \
		$(use_with nls) \
		$(use_with odbc) \
		$(use_with png) \
		$(use_with postgres) \
		$(use_with readline) \
		$(use_with tiff) || die "configure failed!"

	if use wxwindows; then
	    # can't use die here since we need to hack the vdigit build
	    emake -j1
	    ln -sf "${LIBGDI}" dist.${CHOST}/lib/libgdi.so \
		|| die "making libgdi link failed"
	    cd gui/wxpython/vdigit
	    # now we're OK
	    make default -j1 || die "make vdigit failed!"
	else
	    emake -j1 || die "make failed!"
	fi
}

src_install() {
	elog "Grass Home is ${MY_PM}"
	make install UNIX_BIN="${D}"usr/bin BINDIR="${D}"usr/bin \
	    PREFIX="${D}"usr INST_DIR="${D}"usr/${MY_PM} \
	    || die "make install failed!"

	if use wxwindows; then
	    ln -sf "${LIBGDI}" "${D}"usr/${MY_PM}/lib/libgdi.so \
		|| die "failed to find wx library"
	fi

	# get rid of DESTDIR in script path
	sed -i -e "s@${D}@/@" "${D}"usr/bin/${MY_PM}

	# Grass Extension Manager conflicts with ruby gems
	mv "${D}"usr/bin/gem "${D}"usr/${MY_PM}/bin/

	ebegin "Adding env.d and desktop entry for Grass6..."
	    generate_files
	    doenvd 99grass-6
	    if use X; then
		doicon "${FILESDIR}"/grass_icon.png
		domenu ${MY_PM}-grass.desktop
	    fi
	eend ${?}
}

pkg_postinst() {
	use X && fdo-mime_desktop_database_update

	elog "Note this version re-enables support for threads in Tcl and Tk."
	elog "Enable the threads USE flag and rebuild to try it."
}

pkg_postrm() {
	use X && fdo-mime_desktop_database_update
}

generate_files() {
	local GUI="-gui"
	use wxwindows && GUI="-wxpython"

	cat <<-EOF > 99grass-6
	GRASS_LD_LIBRARY_PATH="/usr/${MY_PM}/lib"
	LDPATH="/usr/${MY_PM}/lib"
	MANPATH="/usr/${MY_PM}/man"
	GRASS_HOME="/usr/${MY_PM}"
	EOF

	cat <<-EOF > ${MY_PM}-grass.desktop
	[Desktop Entry]
	Encoding=UTF-8
	Version=1.0
	Name=Grass ${PV}
	Type=Application
	Comment=GRASS Open Source GIS, derived from the original US Army Corps of Engineers project.
	Exec=${TERM} -T Grass -e /usr/bin/${MY_PM} ${GUI}
	Path=
	Icon=grass_icon.png
	Categories=Science;Education;
	Terminal=true
	EOF
}
