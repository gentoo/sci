# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools-utils python-any-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://www.espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/espressomd.git"
	EGIT_BRANCH="master"
	AUTOTOOLS_AUTORECONF=1
	inherit git-r3
else
	SRC_URI="mirror://nongnu/${PN}md/${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="X doc examples +fftw mpi packages test -tk"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	tk? ( X )"

RESTRICT="tk? ( test )"

RDEPEND="${PYTHON_DEPS}
	dev-lang/tcl
	fftw? ( sci-libs/fftw:3.0 )
	mpi? ( virtual/mpi )
	packages? ( dev-tcltk/tcllib )
	tk? ( >=dev-lang/tk-8.4.18-r1 )
	X? ( x11-libs/libX11 )"

DEPEND="${RDEPEND}
	doc? (
		|| ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] )
		dev-texlive/texlive-latexextra
		virtual/latex-base )"

DOCS=( AUTHORS NEWS README ChangeLog )

src_configure() {
	myeconfargs=(
		$(use_with fftw) \
		$(use_with mpi) \
		$(use_with tk) \
		$(use_with X x)
	)
	autotools-utils_src_configure
	restore_config myconfig.h
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile doxygen
	[[ ${PV} = 9999 ]] && use doc && autotools-utils_src_compile ug dg tutorials
}

src_install() {
	local i

	autotools-utils_src_install

	insinto /usr/share/${PN}
	doins ${AUTOTOOLS_BUILD_DIR}/myconfig-sample.h

	save_config ${AUTOTOOLS_BUILD_DIR}/src/myconfig-final.h

	if use doc; then
		if [[ ${PV} = 9999 ]] ; then
			newdoc "${AUTOTOOLS_BUILD_DIR}"/doc/dg/dg.pdf developer_guide.pdf
			newdoc "${AUTOTOOLS_BUILD_DIR}"/doc/ug/ug.pdf user_guide.pdf
			for i in "${AUTOTOOLS_BUILD_DIR}"/doc/tutorials/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		else
			newdoc "${S}"/doc/ug/ug.pdf user_guide.pdf
			for i in "${S}"/doc/tutorials/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		fi
		dohtml -r "${AUTOTOOLS_BUILD_DIR}"/doc/doxygen/html/*
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
	echo
	elog "Please read and cite:"
	elog "ESPResSo, Comput. Phys. Commun. 174(9) ,704, 2006."
	elog "http://dx.doi.org/10.1016/j.cpc.2005.10.005"
	echo
	elog "If you need more features, change"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
	elog "and reemerge with USE=savedconfig"
	echo
	elog "For a full feature list see:"
	elog "/usr/share/${PN}/myconfig-sample.h"
	echo
}
