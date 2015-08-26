# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils multilib

IUSE="doc examples extras +gromacs hdf5"
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
	hdf5? ( sci-libs/hdf5[cxx] )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
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
			"${WORKDIR}/${PN}-manual"
		use examples && mercurial_fetch \
			https://code.google.com/p/votca.csg-tutorials/ \
			votca.csg-tutorials \
			"${WORKDIR}/${PN}-tutorials"
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gromacs GMX)
		$(cmake-utils_use_with hdf5 H5MD)
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
			#we need to do that here, because we need an installed version of csg to build the manual
			[[ ${CHOST} = *-darwin* ]] && \
				emake -C "${WORKDIR}/${PN}"-manual PATH="${PATH}${PATH:+:}${ED}/usr/bin" DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}${DYLD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)" \
				|| emake -C "${WORKDIR}/${PN}"-manual PATH="${PATH}${PATH:+:}${ED}/usr/bin" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)"
			newdoc "${WORKDIR}/${PN}"-manual/manual.pdf "${PN}-manual-${PV}.pdf"
		else
			dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		fi
		cmake-utils_src_make -C "${CMAKE_BUILD_DIR}" html
		dohtml -r "${CMAKE_BUILD_DIR}"/share/doc/html/*
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
