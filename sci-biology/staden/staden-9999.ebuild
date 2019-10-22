# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic fortran-2 multilib subversion

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="http://sourceforge.net/projects/staden/"
ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/${PN}/trunk"

LICENSE="staden"
SLOT="0"
KEYWORDS=""
IUSE="debug doc fortran png tcl tk X zlib"

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
	sci-biology/samtools:0
	>=sci-libs/io_lib-1.13.8
	sys-libs/zlib"
RDEPEND="${DEPEND}
	>=dev-tcltk/iwidgets-4.0
	tcl? ( >=dev-tcltk/itcl-3.2 )
	tk? ( >=dev-tcltk/itk-3.2 )
	net-misc/curl
	doc? ( sci-biology/staden_doc )"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	cd "${WORKDIR}"/"${P}"/src || die
	sed \
		-e 's:svnversion:false:' \
		-i configure.in || die

	AT_M4DIR=ac_stubs autotools-utils_src_prepare
}

src_configure() {
	cd "${WORKDIR}"/"${P}"/src || die
	S="${WORKDIR}"/"${P}"/src
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

src_compile(){
	cd "${WORKDIR}"/"${P}"/src || die
	S="${WORKDIR}"/"${P}"/src
	default
}

src_install() {
	cd "${WORKDIR}"/"${P}"/src || die
	S="${WORKDIR}"/"${P}"/src
	autotools-utils_src_install SVN_VERSION="${ESVN_REVISION}"
	cat >> "${T}"/99staden <<- EOF
	STADENROOT="${EPREFIX}"/usr/share/staden
	LDPATH="${EPREFIX}/usr/$(get_libdir)/staden"
	EOF
	doenvd "${T}"/99staden
}

pkg_postinst(){
	einfo "There is a tutorial at https://sourceforge.net/projects/staden/files/tutorials/1.1/course-1.1.tar.gz"
}
