# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools bash-completion

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
	gromacs? ( >=sci-chemistry/gromacs-4.0.7-r5	<sci-chemistry/gromacs-9999 )
	dev-lang/perl
	app-shells/bash
	doc? ( >=app-text/txt2tags-2.5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	#from bootstrap.sh
	[ -z "${PV##*9999}" ] && \
		emake -C share/scripts/inverse -f Makefile.am.in Makefile.am

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf="--disable-la-files --disable-rc-files"

	if use gromacs; then
		#prefer gromacs double-precision if it is there
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

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README NOTICE
	if use doc; then
		emake CHANGELOG || die "emake CHANGELOG failed"
		dodoc CHANGELOG
	fi

	dobashcompletion scripts/csg-completion.bash ${PN}
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
	bash-completion_pkg_postinst
}
