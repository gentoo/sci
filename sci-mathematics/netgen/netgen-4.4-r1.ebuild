# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib

MY_P=ngs$(delete_version_separator 1)

DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="http://www.hpfem.jku.at/netgen/"
SRC_URI="http://www.hpfem.jku.at/cgi/download.cgi?ID=${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc opencascade lapack gmp"
SLOT="0"

RDEPEND="dev-tcltk/tix
	virtual/opengl
	x11-libs/libXmu
	gmp? ( dev-libs/gmp )
	lapack? ( virtual/lapack )
	opencascade? ( sci-libs/opencascade )"

DEPEND="${RDEPEND}
	lapack? ( dev-util/pkgconfig )"

src_unpack() {

	# workaround bad downloaded file name (gone in 4.5?)
	ln -s "${DISTDIR}/download.cgi?ID=${MY_P}.tar.gz" ${MY_P}.tar.gz
	unpack ./${MY_P}.tar.gz
	mv ${MY_P} ${P}

	cd "${S}"

	# de-hardcode tcl/tk versions
	epatch "${FILESDIR}"/${P}-tkversion.patch
	# fix missing declarations of class and functions and templates
	epatch "${FILESDIR}"/${P}-declarations.patch
	# set default datadir in /usr/share/netgen
	epatch "${FILESDIR}"/${P}-datadir.patch
	# compatibility with c++ stdlib headers and namespace
	epatch "${FILESDIR}"/${P}-stdlib.patch
	# fix missing second argument in order.cpp
	epatch "${FILESDIR}"/${P}-order.patch
	# big patch for makefiles, more generic and allowing shared libs
	epatch "${FILESDIR}"/${P}-makefiles.patch

	# The install location of libtix has changed from 8.2* to 8.4
	local tixver=$(grep -m1 TIX_PATCH_LEVEL /usr/include/tix.h | cut -d \" -f2)
	[[ $(get_version_component_range 3 ${tixver}) = 0 ]] && \
		tixver=$(get_version_component_range 1-2 ${tixver})
	if version_is_at_least "8.4" ${tixver} ; then
		sed -i -e "s:-lTix:-lTix${tixver}:" Makefile
	else
		sed -i -e "s:Tix:tix${tixver}:" Makefile
	fi
}

src_compile() {
	export MACHINE="LINUX"

	# include math libraries
	local mathlibs
	use lapack && mathlibs="${mathlibs} $(pkg-config --libs lapack)"
	use gmp    && mathlibs="${mathlibs} -lgmp"
	sed -i \
		-e "s:#.*lapack.*=*$:lapack = ${mathlibs}:g" \
		Makefile libsrc/makefile.mach.LINUX \
		|| die "sed for math libraries failed"

	local myconf
	use opencascade && myconf="WITH_OCC=1"
	emake ${myconf} || die "emake failed"
}

src_install() {
	dobin ng || die "failed to install binary executable"
	dolib lib/${MACHINE}/*.a lib/${MACHINE}/*.so* \
		|| die "failed to install libraries"
	dodoc VERSION

	# Headers
	insinto /usr/include/${PN}
	doins libsrc/include/*.hpp
	insinto /usr/include/${PN}/ngsolve
	doins ngsolve/*.hpp

	for headers_dir in \
		csg general geom2d gprim interface linalg \
		meshing opti stlgeom visualization; do
		insinto /usr/include/${PN}/${headers_dir}
		doins libsrc/${headers_dir}/*.hpp
	done
	if use opencascade; then
		insinto /usr/include/${PN}/occ
		doins libsrc/occ/*.hpp
	fi

	# tcl files, machine independent
	insinto /usr/share/${PN}
	find . -name "*.tcl" -exec doins {} \;

	# docs
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/ng4.pdf tutorials || die "failed to install doc"
	fi

	# icon and menu entry
	doicon "${FILESDIR}"/netgen.png
	make_desktop_entry ng Netgen netgen.png "Science;NumericalAnalysis"
}

pkg_postinst() {
	elog "Netgen ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=155424"
}
