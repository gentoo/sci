# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools python-single-r1

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="https://github.com/cea-hpc/modules/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+compat test"

DEPEND="
	${PYTHON_DEPS}
	dev-lang/tcl:0=
	dev-tcltk/tclx
	compat? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-util/dejagnu )"

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
		--prefix="${EPREFIX}/usr/share/Modules"
		--datarootdir="${EPREFIX}/usr/share"
		--modulefilesdir="${EPREFIX}/etc/modulefiles"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-python="${PYTHON}"
		$(use_enable compat compat-version)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dosym ../../usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
	dosym ../../usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
	dodir /etc/modulefiles
}
