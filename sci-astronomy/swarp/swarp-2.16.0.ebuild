# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Resample and coadd astronomical FITS images"
HOMEPAGE="http://terapix.iap.fr/soft/swarp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc threads mpi icc"
DEPEND="mpi? ( virtual/mpi )
	icc? ( dev-lang/icc )"

# mpi stuff untested.
src_compile() {
	# trust swarp cflags to be optimized.
	filter-flags ${CFLAGS}
	# --disable-threads does not compile
	local myconf=""
	use threads && myconf="--enable-threads "
	use mpi || export MPICC="$(tc-getCC)"
	econf \
		$(use_enable static ) \
		$(use_enable icc ) \
		$(use_enable mpi ) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*
	fi
}
