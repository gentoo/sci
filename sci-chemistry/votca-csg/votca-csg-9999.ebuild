# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools bash-completion mercurial

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost dev doc static +single-precision double-precision"
use dev && PROPERTIES="interactive"

RDEPEND="dev-libs/expat
	boost? ( >=dev-libs/boost-1.33.1
		=sci-libs/votca-tools-${PV}[boost] )
	!boost? ( =sci-libs/votca-tools-${PV}[-boost] )
	dev? ( =sci-libs/votca-tools-${PV}[dev] )
	!dev? ( =sci-libs/votca-tools-${PV}[-dev] )
	single-precision? ( >sci-chemistry/gromacs-4.0.5[single-precision] )
	double-precision? ( >sci-chemistry/gromacs-4.0.5[double-precision] )
	dev-lang/perl
	app-shells/bash
	doc? ( >=app-text/txt2tags-2.5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

use dev && EHG_REPO_URI="http://dev.votca.org/votca/csg" \
	|| EHG_REPO_URI="https://csg.votca.googlecode.com/hg"

S="${WORKDIR}/${EHG_REPO_URI##*/}"

src_prepare() {
	local dir
	for dir in share/scripts/inverse; do
		emake -C "$dir" -f Makefile.am.in Makefile.am || \
		  die "make -f Makefile.am.in Makefile.am in $dir failed"
	done
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf="--disable-la-files"

	if use single-precision && use double-precision; then
		ewarn "${PN} has only support for single-precision OR double-precision"
		ewarn "using double-precision"
		myconf="${myconf} --with-libgmx=libgmx_d"
	elif use single-precision; then
		myconf="${myconf} --with-libgmx=libgmx"
	elif use double-precision; then
		myconf="${myconf} --with-libgmx=libgmx_d"
	else
		die "Nothing to compile, enable single-precision and/or double-precision"
	fi

	myconf="${myconf} $(use_with boost)"
	myconf="${myconf} $(use_enable static all-static)"

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README NOTICE
	if use doc; then
		emake CHANGELOG || die "emake CHANGELOG failed"
		dodoc CHANGELOG
	fi

	sed -n -e '/^CSGSHARE/p' \
		"${D}"/usr/share/votca/rc/csg.rc.bash >> "${T}/80${PN}"
	doenvd "${T}/80${PN}"

	#from votca-tools
	if [ -f /usr/share/votca/completion.bash ]; then
		cat /usr/share/votca/completion.bash > "${T}/completion.bash"
		cat "${D}"/usr/share/votca/rc/csg-completion.bash >> "${T}/completion.bash"
	    dobashcompletion "${T}"/completion.bash ${PN}
	fi
	rm -f "${D}"/usr/share/votca/rc/*
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
}
