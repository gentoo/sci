# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

inherit eutils multilib flag-o-matic

DESCRIPTION="A three-dimensional finite element mesh generator with built-in pre- and post-processing facilities."
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas chaco cgns doc examples fftw jpeg med metis minimal mpi opencascade png zlib X"

RDEPEND="x11-libs/fltk:1.1
	blas? ( virtual/blas virtual/lapack )
	cgns? ( sci-libs/cgnslib )
	jpeg? ( media-libs/jpeg )
	med? ( >=sci-libs/med-2.3.4 )
	opencascade? ( sci-libs/opencascade )
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )
	fftw? ( sci-libs/fftw:3.0 )
	mpi? ( sys-cluster/openmpi[cxx] )"

DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch
}

src_configure() {
	local myconf=""
	use opencascade && myconf="${myconf} --with-occ-prefix=$CASROOT/lin"

	use minimal && ewarn "minimal USE flag disables most of features"

	if use fftw && use !blas ; then
		die "You MUST compile with the blas USE flag to use the fftw dependency"
		myconf="${myconf} --with-fftw3-prefix=/usr"
	fi

	# I'm not sure if this is needed, but it seems to help in some circumstances
	# see http://bugs.gentoo.org/show_bug.cgi?id=195980#c18
	append-ldflags -ldl -lmpi

	econf ${myconf} \
		$(use_enable X gui) \
		$(use_enable cgns) \
		$(use_enable jpeg) \
		$(use_enable minimal) \
		$(use_enable med) \
		$(use_enable metis) \
		$(use_enable mpi) \
		$(use_enable opencascade occ) \
		$(use_enable png) \
		$(use_enable chaco) \
		$(use_enable zlib)
}

src_compile() {
	emake || die "emake failed"

	if use doc ; then
		cd doc/texinfo
		emake pdf || die "could not build documentation"
	fi
}

src_install() {
	einstall || die "could not install"

	if use doc ; then
		dodoc README doc/{FAQ.txt,README.*,CREDITS.txt} doc/texinfo/*.pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r demos tutorial || die "failed to install examples"
	fi
}
