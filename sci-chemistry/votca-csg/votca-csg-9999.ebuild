# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils multilib

IUSE="doc examples extras +gromacs"
PDEPEND="extras? ( =sci-chemistry/${PN}apps-${PV} )"
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://downloads.votca.googlecode.com/hg/${P}.tar.gz
		doc? ( http://downloads.votca.googlecode.com/hg/${PN}-manual-${PV}.pdf )
		examples? (	http://downloads.votca.googlecode.com/hg/${PN}-tutorials-${PV}.tar.gz )"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://code.google.com/p/votca.csg/"
	KEYWORDS=""
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="=sci-libs/votca-tools-${PV}
	gromacs? ( sci-chemistry/gromacs:= )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	doc? (
		|| ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] )
		dev-texlive/texlive-latexextra
		virtual/latex-base
		dev-tex/pgf
	)
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( README NOTICE )

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		default
	else
		mercurial_src_unpack
		use doc && mercurial_fetch \
			https://code.google.com/p/votca.csg-manual/ \
			votca.csg-manual \
			"${WORKDIR}/manual"
		use examples && mercurial_fetch \
			https://code.google.com/p/votca.csg-tutorials/ \
			votca.csg-tutorials \
			"${WORKDIR}/${PN}-tutorials"
	fi
}

src_configure() {
	local GMX_DEV="OFF" GMX_DOUBLE="OFF" extra

	if use gromacs; then
		has_version =sci-chemistry/gromacs-9999 && GMX_DEV="ON"
		has_version sci-chemistry/gromacs[double-precision] && GMX_DOUBLE="ON"
	fi

	#to create man pages, build tree binaries are executed (bug #398437)
	[[ ${CHOST} = *-darwin* ]] && \
		extra+=" -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF"

	mycmakeargs=(
		$(cmake-utils_use_with gromacs GMX)
		-DWITH_GMX_DEVEL="${GMX_DEV}"
		-DGMX_DOUBLE="${GMX_DOUBLE}"
		-DCMAKE_INSTALL_RPATH="\\\$ORIGIN/../$(get_libdir)"
		${extra}
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newbashcomp scripts/csg-completion.bash csg_call
	for i in "${ED}"/usr/bin/csg_*; do
		[[ ${i} = *csg_call ]] && continue
		bashcomp_alias csg_call "${i##*/}"
	done
	if use doc; then
		if [[ ${PV} = *9999* ]]; then
			pushd "${WORKDIR}"/manual
			[[ ${CHOST} = *-darwin* ]] && \
				export DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}${DYLD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)"
			emake PATH="${PATH}${PATH:+:}${ED}/usr/bin"
			newdoc manual.pdf "${PN}-manual-${PV}.pdf"
			popd > /dev/null
		else
			dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		fi
		cd "${CMAKE_BUILD_DIR}" || die
		cmake-utils_src_make html
		dohtml -r share/doc/html/*
	fi
	if use examples; then
		insinto "/usr/share/doc/${PF}/tutorials"
		docompress -x "/usr/share/doc/${PF}/tutorials"
		doins -r "${WORKDIR}/${PN}"-tutorials*/*
	fi
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	einfo "http://dx.doi.org/10.1021/ct900369w"
	einfo
}
