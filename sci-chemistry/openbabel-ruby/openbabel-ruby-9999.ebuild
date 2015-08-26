# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

inherit cmake-utils eutils ruby-ng git-r3

DESCRIPTION="Ruby bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openbabel/openbabel.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${DEPEND}
	~sci-chemistry/openbabel-${PV}
	>=dev-lang/swig-1.3.29"
RDEPEND="${RDEPEND}
	~sci-chemistry/openbabel-${PV}"

CMAKE_IN_SOURCE_BUILD=1

EGIT_CHECKOUT_DIR="${WORKDIR}/all"

src_unpack() {
	all_ruby_unpack() {
		git-r3_src_unpack
	}

	ruby-ng_src_unpack
}

all_ruby_prepare() {
	swig -ruby -c++ -small -O -templatereduce -naturalvar -autorename \
		-I"${EPREFIX}/usr/include/openbabel-2.0" \
		-o scripts/ruby/openbabel-ruby.cpp \
		-outdir scripts/ruby \
		scripts/openbabel-ruby.i \
		|| die "Generation of openbabel-ruby.cpp failed"
	sed 's/void Init_OpenBabel/void Init_openbabel/' -i scripts/ruby/openbabel-ruby.cpp
}

each_ruby_configure() {
	CMAKE_USE_DIR="${WORKDIR}/${environment}"
	local mycmakeargs=(
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libopenbabel.so
		-DOB_MODULE_PATH="${EPREFIX}"/usr/$(get_libdir)/openbabel/"${PV}"
		-DLIB_INSTALL_DIR="${ED}"/$(ruby_rbconfig_value sitearchdir)
		-DRUBY_BINDINGS=ON
		-DRUBY_EXECUTABLE="${RUBY}"
		-DRUBY_INCLUDE_DIR=$(ruby_get_hdrdir) -I$(ruby_get_hdrdir)/$(ruby_rbconfig_value sitearch)
		-DRUBY_LIBRARY=$(ruby_get_libruby)
	)

	cmake-utils_src_configure
}

each_ruby_compile() {
	CMAKE_USE_DIR="${WORKDIR}/${environment}"
	cmake-utils_src_make bindings_ruby
}

each_ruby_test() {
	for i in scripts/ruby/examples/*
	do
		einfo "Running test: ${WORKDIR}/${environment}/${i}"
		${RUBY} -I"${WORKDIR}/${environment}/$(get_libdir)" "${i}" || die
	done
}

each_ruby_install() {
	CMAKE_USE_DIR="${WORKDIR}/${environment}"
	cmake -DCOMPONENT=bindings_ruby -P cmake_install.cmake
}
