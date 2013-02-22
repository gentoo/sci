# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit base eutils flag-o-matic fortran-2 multilib

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="http://sourceforge.net/projects/staden/"
SRC_URI="
	http://downloads.sourceforge.net/staden/staden-2.0.0b8.tar.gz
	http://sourceforge.net/projects/staden/files/staden/2.0.0b8/staden_doc-2.0.0b8-src.tar.gz"

LICENSE="staden"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
	dev-lang/tk
	dev-tcltk/tklib
	>=media-libs/libpng-1.2
	sci-biology/samtools
	>=sci-libs/io_lib-1.12.2
	>=sys-libs/zlib-1.2
	virtual/fortran"
RDEPEND="${DEPEND}
	>=dev-tcltk/iwidgets-4.0
	tcl? ( >=dev-tcltk/itcl-3.2 )
	tk? ( >=dev-tcltk/itk-3.2 )"

S="${WORKDIR}"/staden-2.0.0b8-src

src_prepare() {
	unpack ${A} || die
	cd "${S}" || die "Cannot cd ${WORKDIR}/staden-2.0.0b8-src"
	epatch "${FILESDIR}"/rpath.patch || die "failed to apply -rpath=/usr/lib/staden patch"
	./bootstrap || die "bootstrap failed"
}

src_configure(){
	local myconf
	use X && myconf=" --with-x"
	myconf=" --with-tklib=/usr/lib/tklib0.5" # HACK
	use amd64 && myconf="${myconf} --enable-64bit"
	use debug && append-cflags "-DCACHE_REF_DEBUG"
	econf ${myconf}
}

src_install() {
	# TODO: dodoc /usr/share/doc/staden/manual/gap4.index ?
	emake install DESTDIR="${D}" || die "make install failed"
	#cd "${WORKDIR}"/staden_doc-2.0.0b8-src || die "failed to cd "${WORKDIR}"/staden_doc-2.0.0b8-src"
	#make install prefix="${D}"/usr || die "failed to install pre-created docs from upstream"

	# install the LDPATH so that it appears in /etc/ld.so.conf after env-update
	# subsequently, apps linked against /usr/lib/staden can be run because
	# loader can find the library (I failed to use '-Wl,-rpath,/usr/lib/staden'
	# somehow for gap2caf, for example
	cat >> "${T}"/99staden <<- EOF
	LDPATH=/usr/$(get_libdir)/staden
	EOF
	doenvd 99staden
}
