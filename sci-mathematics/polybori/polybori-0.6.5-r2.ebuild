# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"

inherit eutils flag-o-matic multilib python scons-utils versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${PN}-$(replace_version_separator 2 '-').tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc gd sage"

# polybori does not have a working set of tests
RESTRICT="mirror test"

CDEPEND=">=dev-libs/boost-1.34.1[python]
	dev-python/ipython
	gd? ( media-libs/gd )"
DEPEND="${CDEPEND}
	>=sci-libs/m4ri-20090512
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"/${PN}-$(get_version_component_range 1-2)

USE_SCONS_TRUE="True"
USE_SCONS_FALSE="False"

src_prepare() {
	if use sage ; then
		# TODO: This should not be done; find a better solution
		cp "${FILESDIR}"/PyPolyBoRi.py pyroot/polybori/PyPolyBoRi.py \
			|| die "cp failed"

		# TODO: Sage needs this file but we should find a better solution,
		# maybe dev-util/pkgconfig ?
		epatch "${FILESDIR}"/${PN}-0.6.4-save-flags.patch
	fi

	# make sure external m4ri is used
	rm -r M4RI || die "failed to remove internal copy of m4ri"

	# make polybori conform to multilib-strict
	sed -i "s:DevelInstPath('lib'):DevelInstPath('$(get_libdir)'):g" \
		SConstruct || die "failed patch library path"

	# Ticket #9768 in Sage's bug tracker - make shared object work
	epatch "${FILESDIR}"/${PN}-0.6.5-fix-double-free-error.patch

	# Ticket #9717 in Sage's bug tracker - fix SIGSEGV errors
	epatch "${FILESDIR}"/${PN}-0.6.5-fix-another-SIGSEGV.patch
}

src_compile(){
	# needed to make polybori linkable
	append-flags -fPIC

	# TODO: handle singular ?

	# store all parameters for scons in a bash array
	myesconsargs=(
		CFLAGS=${CFLAGS}
		CXXFLAGS=${CXXFLAGS}
		LINKFLAGS=${LDFLAGS}
		HAVE_HEVEA=False
		HAVE_L2H=False
		$(use_scons doc HAVE_TEX4HT)
		$(use_scons doc HAVE_DOXYGEN)
		$(use_scons doc HAVE_PYDOC)
		MANDIR="${ED}"/usr/share/man
		PREFIX="${ED}"/usr
		PYINSTALLPREFIX="${ED}"$(python_get_sitedir)
		INSTALLDIR="${ED}"/usr/share/polybori
	)

	escons "${myesconsargs[@]}" prepare-install prepare-devel || die
}

src_install() {
	escons "${myesconsargs[@]}" install devel-install || die

	# remove incomplete documentation
	if ! use doc ; then
		rm -rf "${ED}"/usr/share/polybori/doc \
			|| die "failed to remove useless documentation"
	fi

	# we only need shared objects
	rm "${ED}"/usr/$(get_libdir)/lib*.a \
		|| die "failed to remove static libraries"
}
