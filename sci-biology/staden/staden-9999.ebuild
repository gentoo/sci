# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic fortran-2 multilib subversion

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="http://sourceforge.net/projects/staden/"
SRC_URI=""
ESVN_REPO_URI="https://staden.svn.sourceforge.net/svnroot/staden/staden/trunk/src"

LICENSE="staden"
SLOT="0"
KEYWORDS=""
IUSE="curl debug fortran png tcl tk X zlib"

# either g77 or gfortran must be available
# edit src/mk/linux.mk accordingly
#
# this is a glibc-2.9 issue, see https://sourceforge.net/tracker/index.php?func=detail&aid=2629155&group_id=100316&atid=627058
#
#
#
DEPEND="
	app-arch/xz-utils
	dev-lang/tk:0=
	dev-tcltk/tklib
	media-libs/libpng:0
	sci-biology/samtools
	>=sci-libs/io_lib-1.12.2
	sys-libs/zlib"
RDEPEND="${DEPEND}
	>=dev-tcltk/iwidgets-4.0
	tcl? ( >=dev-tcltk/itcl-3.2 )
	tk? ( >=dev-tcltk/itk-3.2 )"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	sed \
		-e 's:svnversion:false:' \
		-i configure.in || die

	AT_M4DIR=ac_stubs autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=()
	use X && myeconfargs+=( --with-x )
	myeconfargs+=(
		--with-tklib=/usr/$(get_libdir)/tklib
		)
	use amd64 && myeconfargs+=( --enable-64bit )
	use debug && append-cflags "-DCACHE_REF_DEBUG"
		autotools-utils_src_configure
	# edit system.mk to place there proper version number of the svn-controlled checkout
	sed -e "s/^SVNVERS.*/SVNVERS = "${ESVN_REVISION}"/" -i system.mk || die
}

src_install() {
	# TODO: dodoc /usr/share/doc/staden/manual/gap4.index ?
	autotools-utils_src_install SVN_VERSION="${ESVN_REVISION}"

	cat >> "${T}"/99staden <<- EOF
	STADENROOT="${EPREFIX}"/usr/share/staden
	LDPATH="${EPREFIX}/usr/$(get_libdir)/staden"
	EOF

	doenvd "${T}"/99staden
}
