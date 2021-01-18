# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="aee525029bb661b633097e989c6fe2eaa93d2def"

inherit multilib

DESCRIPTION="EST sequence clustering: d2 function, edit distance, common word heuristics"
HOMEPAGE="https://shaze.github.io/wcdest/"
SRC_URI="https://github.com/shaze/wcdest/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	http://www.bioinf.wits.ac.za/~scott/wcd.html
	http://www.bioinf.wits.ac.za/~scott/wcd.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="doc mpi threads"

# This code (0.4.1 at least) has been tested using LAMMPI (RedHat, Suse,
# MacOS X), MPICH (Ubuntu) and MVAPICH (Suse)
DEPEND="mpi? ( sys-cluster/mpich2 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.3-ldflags.patch
	"${FILESDIR}"/${PN}-0.6.3-impl-decl.patch
)

S="${WORKDIR}/${PN}est-${COMMIT}/code"

src_configure(){
	econf \
		$(use_enable mpi) \
		$(use_enable threads pthreads)
}

src_compile() {
	default
	use doc && emake pdf info html
}

src_install() {
	use doc && HTML_DOCS=( doc/wcd.html doc/wcd.pdf doc/wcd.texi )
	emake install PREFIX=/usr LIBDIR="${D}"/usr/$(get_libdir)
	dodoc "${DISTDIR}"/wcd.*
}
