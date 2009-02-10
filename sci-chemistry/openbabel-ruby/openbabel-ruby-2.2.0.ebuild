# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Ruby bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="swig"

RDEPEND="~sci-chemistry/openbabel-2.2.0
	dev-lang/ruby"

DEPEND="${RDEPEND}
	swig? ( >=dev-lang/swig-1.3.29 )"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/openbabel-${PV}"
	cd "${S}"

	local myconf=""
	if use swig ; then
		if ! built_with_use dev-lang/swig ruby ; then
			echo
			eerror "To be able to build openbabel-ruby with swig use"
			eerror "dev-lang/swig has to be merged with ruby enabled."
			eerror "Please, re-emerge dev-lang/swig with USE=\"ruby\"."
			die "dev-lang/swig has been built without ruby support"
		else
			myconf="--enable-maintainer-mode"
		fi
	fi
	econf \
		${myconf} \
		--enable-static \
		|| die "econf failed"
	S="${S}/scripts"
	cd "${S}"
	if use swig ; then
		emake ruby/openbabel_ruby.cpp || die "Failed to make SWIG ruby bindings"
	fi
	S="${S}/ruby"
	cd "${S}"
}

src_compile() {
	ruby ./extconf.rb || die "ruby setup config failed"
	emake || die "ruby setup make failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "ruby setup make install failed"
	dodoc README
}

