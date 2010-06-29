# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$
EAPI=2
inherit eutils elisp-common autotools

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64  ~ppc ~sparc ~x86"

# Supported lisps with readline
SUPP_RL="gcl clisp"
# Supported lisps without readline
SUPP_NORL="cmucl sbcl ecl openmcl"
SUPP_LISPS="${SUPP_RL} ${SUPP_NORL}"
# Default lisp if none selected
DEF_LISP="sbcl"

IUSE="latex emacs tk nls unicode xemacs X ${SUPP_LISPS}"

# Languages
LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

RDEPEND="X? ( x11-misc/xdg-utils
		 sci-visualization/gnuplot[gd]
		 tk? ( dev-lang/tk ) )
	latex? ( virtual/latex-base )
	emacs? ( virtual/emacs
		latex? ( app-emacs/auctex ) )
	xemacs? ( app-editors/xemacs
		latex? ( app-emacs/auctex ) )"

PDEPEND="emacs? ( app-emacs/imaxima )"

# create lisp dependencies
for LISP in ${SUPP_LISPS}; do
	if [ "${LISP}" = "gcl" ]
	then
		RDEPEND="${RDEPEND} gcl? ( >=dev-lisp/gcl-2.6.8_pre[ansi] )"
	else if [ "${LISP}" = "ecl" ]
	then
		RDEPEND="${RDEPEND} ecl? ( >=dev-lisp/ecls-9.8.3 )"
	else if [ "${LISP}" = "openmcl" ]
	then
		RDEPEND="${RDEPEND} openmcl? ( dev-lisp/clozurecl )"
	else
		RDEPEND="${RDEPEND} ${LISP}? ( dev-lisp/${LISP} )"
	fi
	fi
	fi
	DEF_DEP="${DEF_DEP} !${LISP}? ( "
done
DEF_DEP="${DEF_DEP} dev-lisp/${DEF_LISP}"
for LISP in ${SUPP_NORL}; do
	RDEPEND="${RDEPEND} ${LISP}? ( app-misc/rlwrap )"
	[[ ${LISP} = ${DEF_LISP} ]] && \
		DEF_DEP="${DEF_DEP} app-misc/rlwrap"
done
for LISP in ${SUPP_LISPS}; do
	DEF_DEP="${DEF_DEP} )"
done

RDEPEND="${RDEPEND}
	${DEF_DEP}"

DEPEND="${RDEPEND}
	sys-apps/texinfo"

TEXMF=/usr/share/texmf-site
NO_INIT_PATCH_PV="5.19.1"

pkg_setup() {
	LISPS=""

	for LISP in ${SUPP_LISPS}; do
		use ${LISP} && LISPS="${LISPS} ${LISP}"
	done

	for LISP in ${SUPP_NORL}; do
		use ${LISP}
	done

	if [ -z "${LISPS}" ]; then
		ewarn "No lisp specified in USE flags, choosing ${DEF_LISP} as default"
		LISPS="${DEF_LISP}"
	fi
}

src_prepare() {
	# use xdg-open to view ps, pdf
	epatch "${FILESDIR}/${PN}-xdg-utils.patch"

	epatch "${FILESDIR}/${PN}-${NO_INIT_PATCH_PV}-no-init-files.patch"

	# ClozureCL executable name is now ccl
	epatch "${FILESDIR}/${PN}-clozurecl.patch"

	# remove rmaxima if not needed
	epatch "${FILESDIR}/${PN}-rmaxima.patch"

	# see http://osdir.com/ml/sage-devel/2010-04/msg00077.html
	epatch "${FILESDIR}"/${P}-ecl-10.4.1.patch

	# don't install imaxima, since we have a separate package for it
	epatch "${FILESDIR}/${PN}-imaxima.patch"

	# make xmaxima conditional on tk (wish)
	epatch "${FILESDIR}/${PN}-wish.patch"

	eautoreconf
}

src_configure() {
	local myconf=""
	for LISP in ${LISPS}; do
		myconf="${myconf} --enable-${LISP}"
	done

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf \
		$(use_with tk wish) \
		${myconf}
}

src_install() {
	einstall emacsdir="${D}${SITELISP}/${PN}" || die "einstall failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	if use latex; then
		insinto ${TEXMF}/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it from dodoc
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README.lisps || die
	dodir /usr/share/doc
	dosym ../${PN}/${PV}/doc /usr/share/doc/${PF} || die

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el || die
	fi
}

pkg_preinst() {
	# some lisps do not read compress info files (bug #176411)
	for infofile in "${D}"/usr/share/info/*.bz2 ; do
		bunzip2 "${infofile}"
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}
