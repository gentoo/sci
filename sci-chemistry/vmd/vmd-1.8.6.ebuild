# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/vmd/vmd-1.8.6.ebuild,v 1.7 2008/11/12 18:41:47 markusle Exp $

EAPI="1"

inherit eutils toolchain-funcs python

DESCRIPTION="Visual Molecular Dynamics"
LICENSE="vmd"
HOMEPAGE="http://www.ks.uiuc.edu/Research/vmd/"
SRC_URI="${P}.src.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="fetch"

DEPEND="app-shells/tcsh
	x11-libs/libXft
	virtual/opengl
	x11-libs/fltk:1.1
	>=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	>=dev-lang/python-2.3
	sci-biology/stride
	sci-libs/netcdf"

VMD_DOWNLOAD="http://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD"

pkg_nofetch() {
	echo
	einfo "Please download ${SRC_URI} from"
	einfo "${VMD_DOWNLOAD}"
	einfo "after agreeing to the license and then move it to "
	einfo "${DISTDIR}"
	echo
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# apply LINUX-arch patches to vmd configure
	epatch "${FILESDIR}/${P}-config-gentoo.patch"
	epatch "${FILESDIR}/${P}-python-2.5.patch"

	TCL_LIB_PATH="/usr/$(get_libdir)/tcl8.4"
	if has_version =dev-lang/tcl-8.5*; then
		epatch "${FILESDIR}/${P}-tcltk8.5.patch"
		epatch "${FILESDIR}/${P}-fix-crash-on-tcl8.5.patch"
		TCL_LIB_PATH="/usr/$(get_libdir)/tcl8.5"
	fi

	# prepare the plugins

	cd "${WORKDIR}"/plugins

	sed -e "s:CC = gcc:CC = $(tc-getCC):" \
	    -e "s:CXX = g++:CXX = $(tc-getCXX):" \
		-e "s:COPTO = -o :COPTO = -fPIC -o :" \
		-e "s:LOPTO = -o :LOPTO = -fPIC -o :" \
		-e "s:CCFLAGS = -O2 -Wall:CCFLAGS = ${CFLAGS}:" \
		-e "s:CXXFLAGS = -O2 -Wall:CXXFLAGS = ${CXXFLAGS}:" \
		-e "s:SHLD = gcc:SHLD = $(tc-getCC):" \
		-e "s:-ltcl8.4:-ltcl:" \
	    -i Make-arch || die "Failed to set up plugins Makefile"

	sed -e "s:1.0:1.2:" -i vdna/pkgIndex.tcl \
		|| die "Failed to fix vdna plugin"

	# prepare vmd itself

	cd "${S}"

	sed -e "s:gentoo-bindir:${D}/usr/bin:" \
		-e "s:gentoo-libdir:${D}/usr/$(get_libdir):" \
		-i configure || die "failed to adjust install paths"

	sed -e "s:gentoo-gcc:$(tc-getCC):" \
		-e "s:gentoo-g++:$(tc-getCXX):" \
		-e "s:gentoo-cflags:${CFLAGS}:" \
		-i configure || die "Failed to adjust C compiler/flags"

	sed -e "s:gentoo-plugindir:${WORKDIR}/plugins:" \
		-i configure || die "Failed to set up linking to plugin files"

	sed -e "s:gentoo-fltk-include:/usr/include/fltk-1.1:" \
		-e "s:gentoo-fltk-libs:/usr/$(get_libdir)/fltk-1.1:" \
		-i configure || die "failed setting up fltk"

	sed -e "s:gentoo-netcdf-include:/usr/include:" \
		-e "s:gentoo-netcdf-libs:/usr/$(get_libdir):" \
		-i configure || die "failed to set up netcdf"

	# get installed python version
	python_version
	local PY="python${PYVER}"

	sed -e "s:gentoo-python-include:/usr/include/${PY}:" \
		-e "s:gentoo-python-lib:/usr/$(get_libdir)/${PY}:" \
		-e "s:gentoo-python-link:${PY}:" \
		-i configure || die "failed setting up python"

	sed -e "s:LINUXPPC:LINUX:g" \
		-e "s:LINUXALPHA:LINUX:g" \
		-e "s:LINUXAMD64:LINUX:g" \
		-i "${S}"/bin/vmd || die "failed setting up vmd wrapper script"

	local myconfig="LINUX OPENGL FLTK TK TCL PTHREADS PYTHON IMD NETCDF"

	rm -f configure.options && echo $myconfig >> configure.options

	./configure &> /dev/null || die "failed to configure"
}

src_compile() {
	# build plugins
	cd "${WORKDIR}"/plugins

	make LINUX TCLINC="-I/usr/include" \
		TCLLIB=-L/"${TCL_LIB_PATH}" \
		|| die "failed to build plugins"

	# build vmd
	cd "${S}"/src
	emake || die "failed to build vmd"
}

src_install() {
	# install plugins
	cd "${WORKDIR}"/plugins
	PLUGINDIR=${D}/usr/$(get_libdir)/${PN}/plugins make distrib || \
		die "failed to install plugins"

	# install vmd
	cd "${S}"/src
	make install || die "failed to install vmd"

	# export STRIDE_BIN so VMD knows where to find stride
	echo "STRIDE_BIN=/usr/bin/stride" > "${T}"/99${PN} || \
		die "Failed to create vmd env file"
	doenvd "${T}"/99${PN} || die "Failed to install vmd env file"

	# install docs
	cd "${S}"
	dodoc Announcement README doc/ig.pdf doc/ug.pdf

	# remove some of the things we don't want and need in
	# /usr/lib
	cd "${D}"/usr/$(get_libdir)/vmd
	rm -fr doc README Announcement LICENSE || \
		die "failed to clean up /usr/lib/vmd directory"

	# adjust path in vmd wrapper
	sed -e "s:${D}::" -i "${D}"/usr/bin/${PN} \
		|| die "failed to set up vmd wrapper script"
}
