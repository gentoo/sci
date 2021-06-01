# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit autotools python-any-r1

DESCRIPTION="Computational discrete algebra system - minimal GAP core system"
HOMEPAGE="https://www.gap-system.org/"
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV}/gap-${PV}-core.tar.bz2
	https://github.com/gap-system/gap/releases/download/v${PV}/packages-required-v${PV}.tar.gz -> ${P}-core-packages.tar.gz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"
# broken HPC and boehm
IUSE="boehm debug hpc julia julia-gc memcheck valgrind"
REQUIRED_USE="valgrind? ( memcheck ) julia-gc? ( julia ) hpc? ( boehm )"

RDEPEND+="
	dev-libs/gmp
	net-libs/zeromq
	sci-libs/cddlib
	sys-libs/readline
	sys-libs/zlib
	julia? ( || (
		dev-lang/julia
		dev-lang/julia-bin:*
	) )
	valgrind? ( dev-util/valgrind )
"
DEPEND+="${RDEPEND}"
BDEPEND+="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-4.11.0-autoconf.patch )

pkg_setup() {
	if use valgrind; then
		elog "If you enable the use of valgrind duing building"
		elog "be sure that you have enabled the proper flags"
		elog "in gcc to support it:"
		elog "https://wiki.gentoo.org/wiki/Debugging#Valgrind"
	fi
}

src_unpack() {
	default
	mkdir -p "${S}"/pkg || die
	mv "${WORKDIR}"/{GAPDoc*,primgrp*,SmallGrp*,transgrp*} "${S}"/pkg || die
}

src_prepare() {
	default
	eautoreconf -f -i

	# use GNUmakefile
	rm Makefile || die

	# make sure of no external gmp/zlib being build
	# gap uses bundled libatomic_ops and boehm-gc
	rm -rf extern || die

	# this test takes TOO long
	rm tst/teststandard/opers/AutomorphismGroup.tst || die
}

src_configure() {
	addwrite /proc/self
	local myconf=(
		--enable-shared
		--disable-static
		--with-gmp
		--with-zlib
		--with-readline
		--enable-popcnt
		$(use_enable memcheck memory-checking)
		$(use_enable valgrind)
		$(use_enable hpc hpcgap)
		$(use_enable debug)
		$(use_with julia)
	)
	# garbage collector settings
	if use boehm; then
		myconf+=( --with-gc=boehm )
	elif use julia-gc; then
		myconf+=( --with-gc=julia )
	else
		myconf+=( --with-gc=gasman )
	fi

	# only supporting amd64 builds
	econf ${myconf[@]} ABI=64
}

src_test() {
	emake testinstall testlibgap
}

src_install() {
	# upstream has no install function
	# we try to simulate on as best as we can

	dodoc README{,.buildsys,.hpcgap}.md \
		CHANGES.md CITATION

	sed -e "s:^abs_top_builddir=.*$:abs_top_builddir=\"${EPREFIX}/usr/share/gap\":" \
	    -e "s:^abs_top_srcdir=.*$:abs_top_srcdir=\"${EPREFIX}/usr/share/gap\":" \
	    -i gac || die
	dobin gac

	exeinto /usr/share/gap/
	doexe gap

	cat <<-EOF > gap.sh || die
	#!/bin/sh
	exec "${EPREFIX}"/usr/share/gap/gap -l "${EPREFIX}"/usr/share/gap "\$@"
	EOF
	newbin gap.sh gap

	dolib.so .libs/libgap.so*

	dodir /usr/include/gap
	cp -a src/*.h gen/*.h "${ED}"/usr/include/gap || die
	if use hpc; then
		dodir /usr/include/gap/hpc
		cp -a src/hpc/*.h "${ED}"/usr/include/gap/hpc || die
	fi

	cp -a doc grp lib libtool pkg "${ED}"/usr/share/gap || die

	sed -e "s:${S}:${EPREFIX}/usr/share/gap:g" -i sysinfo.gap
	insinto /usr/share/gap
	doins sysinfo.gap*

	# remove objects and static lib files
	find "${ED}" \( -name "*.o" -o -name "*.a"  -o -name "*.la" \) \
	     -delete || die
}
