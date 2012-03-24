# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/espresso/espresso-3.0.0.ebuild,v 1.1 2011/04/20 13:03:00 ottxor Exp $

EAPI=4

inherit autotools-utils savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://www.espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/espressomd.git"
	EGIT_BRANCH="master"
	inherit git-2
else
	SRC_URI="mirror://nongnu/${PN}md/${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="X doc examples fftw mpi packages test -tk"
REQUIRED_USE="tk? ( X )"

RESTRICT="tk? ( test )"

RDEPEND="
	dev-lang/tcl
	fftw? ( sci-libs/fftw:3.0 )
	mpi? ( virtual/mpi )
	tk? ( >=dev-lang/tk-8.4.18-r1 )
	X? ( x11-libs/libX11 )"

DEPEND="${RDEPEND}
	dev-lang/python
	doc? (
		|| ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] )
		virtual/latex-base )"

DOCS=( AUTHORS NEWS README ChangeLog )

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
	restore_config myconfig.h
}

src_configure() {
	myeconfargs=(
		$(use_with fftw) \
		$(use_with mpi) \
		$(use_with tk) \
		$(use_with X x)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile ug doxygen tutorials
	[[ ${PV} = 9999 ]] && use doc && autotools-utils_src_compile dg
}

src_install() {
	local i

	autotools-utils_src_install

	insinto /usr/share/${PN}
	doins ${AUTOTOOLS_BUILD_DIR}/myconfig-sample.h

	save_config ${AUTOTOOLS_BUILD_DIR}/src/myconfig-final.h

	if use doc; then
		[[ ${PV} = 9999 ]] && \
			newdoc ${AUTOTOOLS_BUILD_DIR}/doc/dg/dg.pdf developer_guide.pdf
		newdoc ${AUTOTOOLS_BUILD_DIR}/doc/ug/ug.pdf user_guide.pdf
		dohtml -r ${AUTOTOOLS_BUILD_DIR}/doc/doxygen/html/*
		for i in ${AUTOTOOLS_BUILD_DIR}/doc/tutorials/*/[0-9]*.pdf; do
			newdoc ${i} tutorial_${i##*/}
		done
	fi

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins -r samples/*
	fi

	if use packages; then
		insinto /usr/share/${PN}/packages
		doins -r packages/*
	fi
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "ESPResSo, Comput. Phys. Commun. 174(9) ,704, 2006."
	elog "http://dx.doi.org/10.1016/j.cpc.2005.10.005"
	elog
	elog "If you need more features, change"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
	elog "and reemerge with USE=savedconfig"
	elog
	elog "For a full feature list see:"
	elog "/usr/share/${PN}/myconfig-sample.h"
	elog
}
