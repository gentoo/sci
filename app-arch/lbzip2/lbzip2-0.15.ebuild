# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils flag-o-matic

DESCRIPTION="Pthreads-based parallel bzip2/bunzip2 filter, passable to GNU tar"
HOMEPAGE="http://freshmeat.net/projects/lbzip2"
SRC_URI="http://lacos.web.elte.hu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( app-shells/dash
		sys-process/time )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	append-lfs-flags
	emake CC=$(tc-getCC) || die "emake failed"
}

src_test() {
	if [ -t 0 ] || return; then
		rm -rf "${T}/scratch" "${T}/results" "${T}/rnd"
		hexdump -n 10485760 /dev/urandom > "${T}/rnd"
		emake -j1 SHELL=/bin/dash PATH="${S}:${PATH}" TESTFILE="${T}/rnd" check \
			|| die "make check failed"
	else
		ewarn "make check must be run attached to a terminal"
	fi
}

src_install() {
	dobin ${PN} || die "Installation of ${PN} failed"
	dodoc ChangeLog README || die "no docs"
	doman ${PN}.1 || die "no man"
	insinto "/usr/share/${PN}"
	doins corr-perf.sh malloc_trace.pl || die
}
