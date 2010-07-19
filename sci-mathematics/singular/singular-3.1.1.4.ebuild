# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
WANT_AUTOCONF="2.1" # Upstream ticket 240 -> wontfix

inherit autotools eutils elisp-common flag-o-matic multilib versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators -)
MY_DIR=$(get_version_component_range 1-3 ${MY_PV})
MY_PV_SHARE=${MY_PV}

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${MY_PN}"
SRC_URI="${SRC_COM}-${MY_PV}.tar.gz ${SRC_COM}-${MY_PV_SHARE}-share.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="boost doc emacs examples libsingular +readline"

RDEPEND="dev-libs/gmp
	>=dev-libs/ntl-5.5.1
	emacs? ( >=virtual/emacs-22 )"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost )
	readline? ( sys-libs/readline )
	test? ( dev-util/cmake
			dev-util/cppunit )"

S="${WORKDIR}"/${MY_PN}-${MY_DIR}
SITEFILE=60${PN}-gentoo.el

pkg_setup() {
	append-flags "-fPIC"
	append-ldflags "-fPIC"
	tc-export CC CPP CXX
}

src_prepare () {
	epatch "${FILESDIR}"/${PN}-3.1.0-gentoo.patch
	epatch "${FILESDIR}"/${PN}-3.1.0-emacs-22.patch
	# I don't see a need for the following patch, looks like cruft from
	# older versions to me. The shipped code is fine !
#	epatch "${FILESDIR}"/${PN}-3.1.0-glibc-2.10.patch
	epatch "${FILESDIR}"/${PN}-3.0.4.4-nostrip.patch
	epatch "${FILESDIR}"/${PN}-3.1.1.3-soname.patch

	sed -i \
		-e "/CXXFLAGS/ s/--no-exceptions//g" \
		"${S}"/Singular/configure.in || die

	SOSUFFIX=$(get_version_component_range 1-3)
	sed -i \
		-e "s:SO_SUFFIX = so:SO_SUFFIX = so.${SOSUFFIX}:" \
		"${S}"/Singular/Makefile.in || die

	cd "${S}"/Singular || die "failed to cd into Singular/"
	eautoconf
}

src_configure() {

	econf \
		--prefix="${S}" \
		--disable-debug \
		--disable-doc \
		--disable-NTL \
		--disable-gmp \
		--without-MP \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--enable-Singular \
		$(use_with boost Boost) \
		$(use_enable emacs) \
		$(use_with readline) || die "configure failed"
}

src_compile() {
	emake -j1 || die "emake failed"

	if (use libsingular || use test ) ; then
		emake -j1 libsingular || die "emake libsingular failed"
	fi

	if use emacs; then
		cd "${WORKDIR}"/${MY_PN}/${MY_DIR}/emacs/
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_test() {
	# Tests fail to link -lsingular, upstream ticket #243
	emake -j1 test || die "tests failed"
}

src_install () {
	dodoc README
	# execs and libraries
	cd "${S}"/*-Linux
	dobin ${MY_PN}* gen_test change_cost solve_IP toric_ideal LLL \
		|| die "failed to install binaries"
	insinto /usr/$(get_libdir)/${PN}
	doins *.so || die "failed to install libraries"

	dosym ${MY_PN}-${MY_DIR} /usr/bin/${MY_PN} \
		|| die "failed to create symbolic link"

	if use libsingular; then
		cd "${S}"/Singular
		insinto /usr/include
		doins libsingular.h
		dolib.so libsingular.so."${SOSUFFIX}"
		dosym libsingular.so."${SOSUFFIX}" /usr/$(get_libdir)/libsingular.so \
			|| die "failed to create symlink"
	fi

	# stuff from the share tar ball
	cd "${WORKDIR}"/${MY_PN}/${MY_DIR}
	insinto /usr/share/${PN}
	doins -r LIB  || die "failed to install lib files"
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "failed to install examples"
	fi
	if use doc; then
		dohtml -r html/* || die "failed to install html docs"
		insinto /usr/share/${PN}
		doins doc/singular.idx || die "failed to install idx file"
		cp info/${PN}.hlp info/${PN}.info &&
		doinfo info/${PN}.info \
			|| die "failed to install info files"
	fi
	if use emacs; then
		elisp-install ${PN} emacs/*.el emacs/*.elc emacs/.emacs* \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	if use emacs; then
		echo
		ewarn "Please note that the ESingular emacs wrapper has been"
		ewarn "removed in favor of full fledged singular support within"
		ewarn "Gentoo's emacs infrastructure; i.e. just fire up emacs"
		ewarn "and you should be good to go! See bug #193411 for more info."
		echo
	fi

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
