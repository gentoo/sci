# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils eutils flag-o-matic fortran-2 multilib

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="http://sourceforge.net/projects/staden"
SRC_URI="http://downloads.sourceforge.net/staden/staden-${PV/_beta/b}-src.tar.gz"

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

S="${WORKDIR}"/staden-${PV/_beta/b}-src

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-zlib.patch )

src_prepare() {
	sed \
		-e 's:svnversion:false:' \
		-i configure.in || die

	AT_M4DIR=ac_stubs autotools-utils_src_prepare
}

src_configure(){
	local myeconfargs=()
	use X && myeconfargs+=( --with-x )
	myeconfargs+=(
		--with-tklib=/usr/$(get_libdir)/tklib
		)
	use amd64 && myeconfargs+=( --enable-64bit )
	use debug && append-cflags "-DCACHE_REF_DEBUG"
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
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
