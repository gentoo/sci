# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils bash-completion

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
IUSE="+gromacs static-libs"

RDEPEND="=sci-libs/votca-tools-${PV}
	gromacs? ( >=sci-chemistry/gromacs-4.0.7-r5	<sci-chemistry/gromacs-9999 )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	>=app-text/txt2tags-2.5
	dev-util/pkgconfig"

src_prepare() {
	#from bootstrap.sh
	[ -z "${PV##*9999}" ] && \
		emake -C share/scripts/inverse -f Makefile.am.in Makefile.am

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local libgmx="libgmx"

	#prefer gromacs double-precision if it is there
	has_version sci-chemistry/gromacs[double-precision] && libgmx="libgmx_d"

	myeconfargs=( ${myconf} --disable-rc-files  $(use_with gromacs libgmx $libgmx) )
	autotools-utils_src_configure
}

src_install() {
	DOCS=(README NOTICE ${AUTOTOOLS_BUILD_DIR}/CHANGELOG)
	dobashcompletion scripts/csg-completion.bash ${PN}
	autotools-utils_src_install
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
	bash-completion_pkg_postinst
}
