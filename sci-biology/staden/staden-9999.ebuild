# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit base eutils flag-o-matic fortran-2 multilib subversion

if [ "$PV" == "9999" ]; then
	inherit autotools
fi

DESCRIPTION="DNA sequence assembly (gap4, gap5), editing and analysis tools (Spin)"
HOMEPAGE="http://sourceforge.net/projects/staden/"
# https://staden.svn.sourceforge.net/svnroot/staden staden
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="https://staden.svn.sourceforge.net/svnroot/staden/staden/trunk"
else
	SRC_URI="http://downloads.sourceforge.net/staden/staden-2.0.0b7-src.tar.gz"
fi

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

src_unpack() {
	if [ "$PV" == "9999" ]; then
		subversion_src_unpack
		S="${WORKDIR}"/"${P}"/src/ || die
		cd "${S}" || die
		./bootstrap || die "bootstrap failed"
	else
		unpack ${A} || die
		S="${WORKDIR}"/staden-2.0.0b7-src || die "Cannot cd ${WORKDIR}/staden-2.0.0b7-src"
		cd "${S}" || die "Cannot cd ${S}"
		./bootstrap || die "bootstrap failed"
	fi
}

src_configure() {
	local myconf
	use X && myconf=" --with-x"
	myconf=" --with-tklib=/usr/lib/tklib0.5" # HACK, see http://bugs.gentoo.org/show_bug.cgi?id=311847#c10
	use amd64 && myconf="${myconf} --enable-64bit"
	use debug && append-cflags "-DCACHE_REF_DEBUG"
	use debug && append-cxxflags "-DCACHE_REF_DEBUG"
	econf ${myconf}
	# edit system.mk to place there proper version number of the svn-controlled checkout
	SVNVERSION=`svnversion ${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}`
	sed -e "s/^SVNVERS.*/SVNVERS = "${SVNVERSION}"/" -i system.mk
}

src_install() {
	# TODO: dodoc /usr/share/doc/staden/manual/gap4.index ?
	emake install DESTDIR="${D}" SVN_VERSION="${SVNVERSION}" || die "make install failed"

	cat >> "${S}"/99staden <<- EOF
	STADENROOT="${EPREFIX}"/usr/share/staden
	EOF

	doenvd "${S}"/99staden || die
}
