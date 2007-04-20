# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Program that simulates astronomical images"
HOMEPAGE="http://terapix.iap.fr/soft/skymaker"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads mpi"
RESTRICT="test"

DEPEND=">=sci-libs/fftw-3
	mpi? ( virtual/mpi )"

# mpi stuff untested.
src_compile() {
	use mpi || export MPICC="$(tc-getCC)"
	local myconf
	# --disable-threads is buggy
	use threads && myconf="--enable-threads"
	econf \
		$(use_enable mpi) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS
}
