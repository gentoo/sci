# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils elisp-common flag-o-matic multilib prefix versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators '.')
# Consistency is different...
MY_DIR2=$(get_version_component_range 1-3 ${PV})
MY_DIR=$(replace_all_version_separators '-' ${MY_DIR2})

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~x86-macos"
IUSE="boost doc emacs examples python +readline"

RDEPEND="dev-libs/gmp
	>=dev-libs/ntl-5.5.1
	emacs? ( >=virtual/emacs-22 )"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost )
	readline? ( sys-libs/readline )"

SITEFILE=60${PN}-gentoo.el

S="${WORKDIR}/${PN}-${MY_DIR2}"

pkg_setup() {
	append-flags "-fPIC"
	append-ldflags "-fPIC"
	tc-export AR CC CPP CXX

	# Ensure that >=emacs-22 is selected
	if use emacs; then
		elisp-need-emacs 22 || die "Emacs version too low"
	fi
}

src_prepare () {
	# Need to do something about resources later...
	# epatch "${FILESDIR}"/${PN}-4.0.0-gentoo.patch

	# omalloc's old configure will fail if ar is not exactly 'ar'.
	epatch "${FILESDIR}"/${PN}-4.0.0-fix-omalloc-ar-detection.patch

	cd "${S}"/omalloc || die "failed to cd into omalloc directory"
	eautoreconf
}

src_configure() {
	econf \
#		--prefix="${S}"/build \
#		--exec-prefix="${S}"/build \
#		--bindir="${S}"/build/bin \
#		--libdir="${S}"/build/lib \
#		--libexecdir="${S}"/build/lib \
#		--includedir="${S}"/build/include \
		--with-gmp="${EPREFIX}"/usr \
		--with-ntl \
		--disable-debug \
		--disable-doc \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
#		--enable-Singular \
		$(use_with python python embed) \
		$(use_with boost Boost) \
		$(use_enable emacs) \
		$(use_with readline) || die "configure failed"
}

src_compile() {
	emake || die "emake failed"

	if use emacs; then
		cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}/emacs/
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_test() {
	emake test || die "tests failed"
}

# src_install () {
# 	dodoc README
# 	# execs and libraries
# 	cd "${S}"/build/bin
# 	dobin ${MY_PN}* gen_test change_cost solve_IP toric_ideal LLL \
# 		|| die "failed to install binaries"
# 	insinto /usr/$(get_libdir)/${PN}
# 	doins *.so || die "failed to install libraries"
#
# 	dosym ${MY_PN}-${MY_DIR} /usr/bin/${MY_PN} \
# 		|| die "failed to create symbolic link"
#
# 	# stuff from the share tar ball
# 	cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}
# 	insinto /usr/share/${PN}
# 	doins -r LIB  || die "failed to install lib files"
# 	if use examples; then
# 		insinto /usr/share/doc/${PF}
# 		doins -r examples || die "failed to install examples"
# 	fi
# 	if use doc; then
# 		dohtml -r html/* || die "failed to install html docs"
# 		insinto /usr/share/${PN}
# 		doins doc/singular.idx || die "failed to install idx file"
# 		cp info/${PN}.hlp info/${PN}.info &&
# 		doinfo info/${PN}.info \
# 			|| die "failed to install info files"
# 	fi
# 	if use emacs; then
# 		elisp-install ${PN} emacs/*.el emacs/*.elc emacs/.emacs* \
# 			|| die "elisp-install failed"
# 		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
# 	fi
# }

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
