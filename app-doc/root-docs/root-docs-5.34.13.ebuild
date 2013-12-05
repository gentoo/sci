# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/root-docs/root-docs-5.34.07.ebuild,v 1.1 2013/05/23 23:50:00 bicatali Exp $

EAPI=5

ROOT_PN="root"
PATCH_PV="5.34.01"

if [[ ${PV} == "9999" ]] ; then
	_GIT=git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://root.cern.ch/${ROOT_PN}/${ROOT_PN}_v${PV}.source.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

inherit eutils multilib toolchain-funcs virtualx ${_GIT}

DESCRIPTION="API documentation for ROOT (An Object-Oriented Data Analysis Framework)"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

S="${WORKDIR}/${ROOT_PN}"
VIRTUALX_REQUIRED="always"

DEPEND="
	~sci-physics/root-${PV}[X,doc,graphviz,htmldoc,opengl]
	virtual/pkgconfig
	${_GIT_DEP}"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-makehtml.patch
}

src_configure() {
	# we need only to setup paths here, html docs doesn't depend on USE flags
	./configure \
		--prefix="${EPREFIX}"/usr \
		--etcdir="${EPREFIX}"/etc/root \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--tutdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tutorials \
		--testdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tests \
		--with-cc=$(tc-getCC) \
		--with-cxx=$(tc-getCXX) \
		--with-f77=$(tc-getFC) \
		--with-ld=$(tc-getCXX) \
		--with-afs-shared=yes \
		--with-llvm-config="${EPREFIX}"/usr/bin/llvm-config \
		--with-sys-iconpath="${EPREFIX}"/usr/share/pixmaps \
		--nohowto
}

src_compile() {
	# video drivers may want to access hardware devices
	cards=$(echo -n /dev/dri/card* /dev/ati/card* /dev/nvidiactl* | sed 's/ /:/g')
	[[ -n "${cards}" ]] && addpredict "${cards}"

	ROOTSYS="${S}" Xemake html
	# if root.exe crashes, return code will be 0 due to gdb attach,
	# so we need to check if last html file was generated;
	# this check is volatile and can't catch crash on the last file.
	[[ -f htmldoc/timespec.html ]] || die "looks like html doc generation crashed"
}

src_install() {
	dodir /usr/share/doc/${PF}
	# too large data to copy
	mv htmldoc/* "${ED}usr/share/doc/${PF}/"
	docompress -x "${EPREFIX}/usr/share/doc/${PF}/"
}
