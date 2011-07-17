# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit bash-completion cmake-utils

MANUAL_PV=1.2
TUTORIAL_PV=1.2
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz
		doc? ( http://votca.googlecode.com/files/votca-manual-${MANUAL_PV}.pdf )
		examples? (	http://votca.googlecode.com/files/votca-tutorials-${TUTORIAL_PV}.tar.gz )"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://csg.votca.googlecode.com/hg"
	EHG_REVISION="default"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
	PDEPEND="doc? ( =app-doc/votca-csg-manual-${PV} )
		examples? ( =sci-chemistry/votca-csg-tutorials-${PV} )"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost doc examples +gromacs"

RDEPEND="=sci-libs/votca-tools-${PV}[boost=]
	gromacs? ( sci-chemistry/gromacs )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[-nodot] )
	>=app-text/txt2tags-2.5
	dev-util/pkgconfig"

src_configure() {
	local extra="-DWITH_GMX_DEVEL=OFF"

	use gromacs && has_version =sci-chemistry/gromacs-9999 && \
		extra="-DWITH_GMX_DEVEL=ON"

	mycmakeargs=(
		$(cmake-utils_use boost EXTERNAL_BOOST)
		$(cmake-utils_use_with gromacs GMX)
		${extra}
		-DWITH_RC_FILES=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	DOCS=(README NOTICE ${CMAKE_BUILD_DIR}/CHANGELOG)
	dobashcompletion scripts/csg-completion.bash ${PN}
	cmake-utils_src_install
	if use doc; then
		if [ -n "${PV##*9999}" ]; then
			dodoc "${DISTDIR}/votca-manual-${MANUAL_PV}.pdf"
		fi
		cd "${CMAKE_BUILD_DIR}" || die
		cd share/doc || die
		doxygen || die
		dohtml -r html/*
	fi
	if use examples && [ -n "${PV##*9999}" ]; then
		insinto "/usr/share/doc/${PF}/tutorials"
		docompress -x "/usr/share/doc/${PF}/tutorials"
		doins -r "${WORKDIR}/votca-tutorials-${TUTORIAL_PV}"/*
	fi
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
	bash-completion_pkg_postinst
}
