# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils git-2

DESCRIPTION="A sequence motif discovery tool that uses discriminative learning"
HOMEPAGE="https://github.com/maaskola/discrover"
EGIT_REPO_URI="https://github.com/maaskola/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dreme doc +logo +rmathlib tcmalloc"

RDEPEND="
	dev-libs/boost
	dreme? ( sci-biology/meme )
	logo? ( dev-texlive/texlive-latex dev-tex/pgf dev-tex/xcolor media-gfx/imagemagick )
	rmathlib? ( dev-lang/R )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
	doc? ( dev-texlive/texlive-latex dev-texlive/texlive-latexextra dev-texlive/texlive-latexrecommended media-gfx/imagemagick )
"
src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with rmathlib RMATHLIB)
		$(cmake-utils_use_with dreme DREME)
		$(cmake-utils_use_with tcmalloc TCMALLOC)
		$(cmake-utils_use_with doc DOC)
	)

	unset R_HOME

	if use rmathlib ; then
		elog
		elog "Using statistical routines from standalone Rmathlib."
		elog
	fi
	if use dreme ; then
		elog
		elog "Linking to DREME from the MEME suite."
		elog
	else
		elog
		elog "Not linking to DREME from the MEME suite (sci-biology/meme)."
		elog "You will not be able to use DREME to find seeds."
		elog
	fi

	if use doc ; then
		elog
		elog "User manual available at /usr/share/doc/discrover/discrover-manual.pdf"
		elog
	fi

	cmake-utils_src_configure
}
