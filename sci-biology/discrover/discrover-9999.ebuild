# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils git-r3

DESCRIPTION="A sequence motif discovery tool that uses discriminative learning"
HOMEPAGE="https://github.com/maaskola/discrover"
SRC_URI=""
EGIT_REPO_URI="https://github.com/maaskola/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cairo dreme doc +lto misc_scripts +rmathlib tcmalloc"

RDEPEND="
	dev-libs/boost
	cairo? ( x11-libs/cairo )
	dreme? ( sci-biology/meme )
	rmathlib? ( dev-lang/R )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
	doc? (
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
		media-gfx/imagemagick
	)
	lto? ( >=sys-devel/gcc-4.8:* )
"
pkg_pretend() {
	if use lto; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ) ; then
			eerror "Compilation with link-time optimization and GCC older than 4.8 is not supported."
			eerror "Please either disable the USE flag 'lto' or use >=sys-devel/gcc-4.8."
			die "Compiling with USE flag 'lto' is not supported with <sys-devel/gcc-4.8."
		fi
	fi
}
src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with cairo CAIRO)
		$(cmake-utils_use_with dreme DREME)
		$(cmake-utils_use_with doc DOC)
		$(cmake-utils_use_with lto LTO)
		$(cmake-utils_use_with misc_scripts MISC_SCRIPTS)
		$(cmake-utils_use_with rmathlib RMATHLIB)
		$(cmake-utils_use_with tcmalloc TCMALLOC)
		-DDOC_DIR="${EPREFIX}${PREFIX}/share/doc/${PF}"
	)

	unset R_HOME

	if use rmathlib ; then
		echo
		elog "Using statistical routines from standalone Rmathlib."
		echo
	fi
	if use dreme ; then
		echo
		elog "Linking to DREME from the MEME suite."
		echo
	else
		echo
		elog "Not linking to DREME from the MEME suite (sci-biology/meme)."
		elog "You will not be able to use DREME to find seeds."
		echo
	fi

	if use doc ; then
		echo
		elog "User manual available at /usr/share/doc/discrover/discrover-manual.pdf"
		echo
	fi

	cmake-utils_src_configure
}
