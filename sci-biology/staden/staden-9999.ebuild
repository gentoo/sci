# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic fortran-2 multilib subversion

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="https://sourceforge.net/projects/staden/"
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

src_prepare() {
	default
	sed \
		-e 's:svnversion:false:' \
		-i configure.in || die
}

src_configure(){
	use debug && append-cflags "-DCACHE_REF_DEBUG"
	econf \
		$(use_enable X x) \
		$(use_enable amd64 64bit) \
		--with-tklib="/usr/$(get_libdir)/tklib"
}

src_install() {
	default
	# install the LDPATH so that it appears in /etc/ld.so.conf after env-update
	# subsequently, apps linked against /usr/lib/staden can be run because
	# loader can find the library (I failed to use '-Wl,-rpath,/usr/lib/staden'
	# somehow for gap2caf, for example
	cat >> "${T}"/99staden <<- EOF
	STADENROOT="${EPREFIX}"/usr/share/staden
	LDPATH="${EPREFIX}/usr/$(get_libdir)/staden"
	EOF
	doenvd "${T}"/99staden
}

pkg_postinst(){
	einfo "There is a tutorial at https://sourceforge.net/projects/staden/files/tutorials/1.1/course-1.1.tar.gz"
}
