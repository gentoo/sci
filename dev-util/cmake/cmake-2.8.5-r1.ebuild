# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cmake/cmake-2.8.5.ebuild,v 1.1 2011/07/11 16:50:44 scarabeus Exp $

EAPI=4

inherit elisp-common toolchain-funcs eutils versionator flag-o-matic base cmake-utils virtualx

MY_P="${PN}-$(replace_version_separator 3 - ${MY_PV})"

DESCRIPTION="Cross platform Make"
HOMEPAGE="http://www.cmake.org/"
SRC_URI="http://www.cmake.org/files/v$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="CMake"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="emacs ncurses qt4 vim-syntax"

DEPEND="
	>=app-arch/libarchive-2.8.0
	>=net-misc/curl-7.20.0-r1[ssl]
	>=dev-libs/expat-2.0.1
	dev-util/pkgconfig
	sys-libs/zlib
	ncurses? ( sys-libs/ncurses )
	qt4? ( x11-libs/qt-gui:4 )
"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
"

SITEFILE="50${PN}-gentoo.el"
VIMFILE="${PN}.vim"

S="${WORKDIR}/${MY_P}"

CMAKE_BINARY="${S}/Bootstrap.cmk/cmake"

# Fixme:
# Boost patchset is foobared and should respect eselect / slotting
PATCHES=(
	"${FILESDIR}"/${PN}-2.6.3-darwin-bundle.patch
	"${FILESDIR}"/${PN}-2.6.3-no-duplicates-in-rpath.patch
	"${FILESDIR}"/${PN}-2.6.3-fix_broken_lfs_on_aix.patch
	"${FILESDIR}"/${PN}-2.8.0-darwin-default-install_name.patch
	"${FILESDIR}"/${PN}-2.8.1-libform.patch
	"${FILESDIR}"/${PN}-2.8.4-FindPythonLibs.patch
	"${FILESDIR}"/${PN}-2.8.4-FindPythonInterp.patch
	"${FILESDIR}"/${PN}-2.8.3-more-no_host_paths.patch
	"${FILESDIR}"/${PN}-2.8.3-ruby_libname.patch
	"${FILESDIR}"/${PN}-2.8.4-FindBoost.patch
	"${FILESDIR}"/${PN}-2.8.5-FindBLAS.patch
	"${FILESDIR}"/${PN}-2.8.5-FindLAPACK.patch
)
cmake_src_bootstrap() {
	# Cleanup args to extract only JOBS.
	# Because bootstrap does not know anything else.
	echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' > /dev/null
	if [ $? -eq 0 ]; then
		par_arg=$(echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' | egrep -o '[[:digit:]]+')
		par_arg="--parallel=${par_arg}"
	else
		par_arg="--parallel=1"
	fi

	tc-export CC CXX LD

	./bootstrap \
		--prefix="${T}/cmakestrap/" \
		${par_arg} \
		|| die "Bootstrap failed"
}

cmake_src_test() {
	# fix OutDir test
	# this is altered thanks to our eclass
	sed -i -e 's:#IGNORE ::g' "${S}"/Tests/OutDir/CMakeLists.txt || die
	pushd "${CMAKE_BUILD_DIR}" > /dev/null
	# Excluded tests:
	#    BootstrapTest: we actualy bootstrap it every time so why test it.
	#    SimpleCOnly_sdcc: sdcc choke on global cflags so just skip the test
	#        as it was never intended to be used this way.
	"${CMAKE_BUILD_DIR}"/bin/ctest \
		-E BootstrapTest SimpleCOnly_sdcc \
		|| die "Tests failed"
	popd > /dev/null
}

src_prepare() {
	base_src_prepare

	# disable running of cmake in boostrap command
	sed -i \
		-e '/"${cmake_bootstrap_dir}\/cmake"/s/^/#DONOTRUN /' \
		bootstrap || die "sed failed"

	# Add gcc libs to the default link paths
	sed -i \
		-e "s|@GENTOO_PORTAGE_GCCLIBDIR@|${EPREFIX}/usr/${CHOST}/lib/|g" \
		-e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}/|g" \
		Modules/Platform/{UnixPaths,Darwin}.cmake || die "sed failed"

	cmake_src_bootstrap
}

src_configure() {
	# make things work with gentoo java setup
	# in case java-config cannot be run, the variable just becomes unset
	# per bug #315229
	export JAVA_HOME=$(java-config -g JAVA_HOME 2> /dev/null)

	local mycmakeargs=(
		-DCMAKE_USE_SYSTEM_LIBRARIES=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DCMAKE_DOC_DIR=/share/doc/${PF}
		-DCMAKE_MAN_DIR=/share/man
		-DCMAKE_DATA_DIR=/share/${PN}
		$(cmake-utils_use_build ncurses CursesDialog)
		$(cmake-utils_use_build qt4 QtDialog)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use emacs && elisp-compile Docs/cmake-mode.el
}

src_test() {
	VIRTUALX_COMMAND="cmake_src_test" virtualmake
}

src_install() {
	cmake-utils_src_install
	if use emacs; then
		elisp-install ${PN} Docs/cmake-mode.el Docs/cmake-mode.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins Docs/cmake-syntax.vim

		insinto /usr/share/vim/vimfiles/indent
		doins Docs/cmake-indent.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}/${VIMFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
