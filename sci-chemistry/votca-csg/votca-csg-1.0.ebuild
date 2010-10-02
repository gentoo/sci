# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools bash-completion eutils

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://csg.votca.googlecode.com/hg"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc +gromacs static-libs"

RDEPEND="=sci-libs/votca-tools-${PV}
	>sci-chemistry/gromacs-4.0.7-r1
	dev-lang/perl
	app-shells/bash
	doc? ( >=app-text/txt2tags-2.5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf="--disable-la-files"

	if use gromacs; then
		if has_version sci-chemistry/gromacs[double-precision]; then
			myconf="${myconf} --with-libgmx=libgmx_d"
		else
			myconf="${myconf} --with-libgmx=libgmx"
		fi
	else
		myconf="${myconf} --without-libgmx"
	fi

	myconf="${myconf} $(use_enable static-libs static)"

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
		"${ED}"/usr/share/votca/rc/csg.rc.bash >> "${T}/80${PN}"
	doenvd "${T}/80${PN}"

	#from votca-tools
	if [ -f /usr/share/votca/completion.bash ]; then
		cat /usr/share/votca/completion.bash > "${T}/completion.bash"
		cat "${ED}"/usr/share/votca/rc/csg-completion.bash >> "${T}/completion.bash"
	    dobashcompletion "${T}"/completion.bash ${PN}
	fi
	rm -f "${ED}"/usr/share/votca/rc/*
}

pkg_postinst() {
	env-update
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
}

pkg_postrm() {
	env-update
}
