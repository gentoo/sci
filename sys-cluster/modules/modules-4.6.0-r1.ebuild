# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit autotools python-single-r1

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="https://github.com/cea-hpc/modules/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="compat test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	dev-lang/tcl:0=
	dev-tcltk/tclx
	compat? ( x11-libs/libX11 )
"
# lmod is strong blocked since both want to install a module binary
RDEPEND="
	${DEPEND}
	!sys-cluster/lmod
"
BDEPEND="
	test? ( dev-util/dejagnu )
"

src_prepare() {
	default

	cd "${S}/lib" || die
	eautoreconf

	if use compat; then
		cd "${S}/compat" || die
		eautoreconf
	fi
}

src_configure() {
	local myconf=(
		--disable-versioning
		--with-initconf-in=etcdir
		--enable-multilib-support
		--disable-set-shell-startup
		--prefix="${EPREFIX}/usr/share/Modules"
		--mandir="${EPREFIX}/usr/share/man"
		--docdir="${EPREFIX}/usr/share/doc/${P}"
		--libdir="${EPREFIX}/usr/share/Modules/$(get_libdir)"
		--datarootdir="${EPREFIX}/usr/share"
		--modulefilesdir="${EPREFIX}/etc/modulefiles"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-python="${PYTHON}"
		--with-quarantine-vars="LD_LIBRARY_PATH LD_PRELOAD"
		$(use_enable compat compat-version)
	)
	econf "${myconf[@]}" "${EXTRA_ECONF[@]}" || die "configure failed"
}

src_test() {
	# Remove known-broken tests
	# These test fine, but fail for random differences in the gentoo environment
	rm "${S}"/testsuite/modules.70-maint/210-clear.exp || die "rm failed"
	rm "${S}"/testsuite/modules.00-init/110-quar.exp || die "rm failed"

	RUNTESTARGS=-v emake test
}

src_install() {
	default
	dosym ../../usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
	dosym ../../usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
	dodir /etc/modulefiles
}
