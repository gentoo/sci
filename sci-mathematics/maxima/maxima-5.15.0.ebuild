# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils elisp-common

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 AECA"
SLOT="0"
KEYWORDS="~x86"

# Supported lisps with readline
SUPP_RL="gcl clisp"
# Supported lisps without readline
SUPP_NORL="cmucl sbcl"
SUPP_LISPS="${SUPP_RL} ${SUPP_NORL}"
# Default lisp if none selected
DEF_LISP="sbcl"

IUSE="latex emacs tk nls unicode xemacs X ${SUPP_LISPS} ${IUSE}"

# Languages
LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

# tetex>=3, so no use of virtual/latex-base (bug #203558)
# >=maxima-5.15.0 includes imaxima; it depends on dev-tex/mh
RDEPEND="!app-emacs/imaxima
	X? ( x11-misc/xdg-utils
			  sci-visualization/gnuplot
			  tk? ( dev-lang/tk ) )
	latex? ( || ( dev-texlive/texlive-latexrecommended
				  >=app-text/tetex-3
				  app-text/ptex ) )
	emacs? ( virtual/emacs latex? ( app-emacs/auctex dev-tex/mh ) )
	xemacs? ( virtual/xemacs latex? ( app-xemacs/auctex dev-tex/mh ) )"

# create lisp dependencies
for LISP in ${SUPP_LISPS}; do
	RDEPEND="${RDEPEND} ${LISP}? ( dev-lisp/${LISP} )"
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

pkg_setup() {
	LISPS=""

	for LISP in ${SUPP_LISPS}; do
		use ${LISP} && LISPS="${LISPS} ${LISP}"
	done

	if [ -z "${LISPS}" ]; then
		ewarn "No lisp specified in USE flags, choosing ${DEF_LISP} as default"
		LISPS="${DEF_LISP}"
	fi

	RL=""

	for LISP in ${SUPP_NORL}; do
		use ${LISP} && RL="yes"
	done

	if use gcl; then
		if ! built_with_use dev-lisp/gcl ansi; then
			eerror "gcl must be emerged with the USE flag ansi"
			die "This package needs gcl with USE=ansi"
		fi
		# gcl in the main tree is broken (bug #205803)
		ewarn "Please use gcl from http://repo.or.cz/w/gentoo-lisp-overlay.git"
	fi

	# Calculating MAXIMA_TEXMFDIR
	if use latex; then
		local TEXMFPATH="$(kpsewhich -var-value=TEXMFSITE)"
		local TEXMFCONFIGFILE="$(kpsewhich texmf.cnf)"

		if [ -z "${TEXMFPATH}" ]; then
			eerror "You haven't defined the TEXMFSITE variable in your TeX config."
			eerror "Please do so in the file ${TEXMFCONFIGFILE:-/var/lib/texmf/web2c/texmf.cnf}"
			die "Define TEXMFSITE in TeX configuration!"
		else
			# go through the colon separated list of directories
			# (maybe only one) provided in the variable
			# TEXMFPATH (generated from TEXMFSITE from TeX's config)
			# and choose only the first entry.
			# All entries are separated by colons, even when defined
			# with semi-colons, kpsewhich changes
			# the output to a generic format, so IFS has to be redefined.
			local IFS="${IFS}:"

			for strippedpath in ${TEXMFPATH}; do
				if [ -d ${strippedpath} ]; then
					MAXIMA_TEXMFDIR="${strippedpath}"
					break
				fi
			done

			# verify if an existing path was chosen to prevent from
			# installing into the wrong directory
			if [ -z ${MAXIMA_TEXMFDIR} ]; then
				eerror "TEXMFSITE does not contain any existing directory."
				eerror "Please define an existing directory in your TeX config file"
				eerror "${TEXMFCONFIGFILE:-/var/lib/texmf/web2c/texmf.cnf} or create at least one of the there specified directories"
				die "TEXMFSITE variable did not contain an existing directory"
			fi
		fi
	fi

	if use X && ! built_with_use sci-visualization/gnuplot gd; then
		elog "To benefit full plotting capability of maxima,"
		elog "enable the gd USE flag for sci-visualization/gnuplot"
		elog "Then re-emerge maxima"
		epause 5
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# use xdg-open to view ps, pdf
	epatch "${FILESDIR}"/${PN}-xdg-utils.patch
	epatch "${FILESDIR}"/${PN}-no-init-files.patch
	# remove rmaxima if neither cmucl nor sbcl
	if [ -z "${RL}" ]; then
		sed -i \
			-e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' \
			"${S}"/src/Makefile.in \
			|| die "sed for rmaxima failed"
	fi
}

src_compile() {
	local myconf=""
	for LISP in ${LISPS}; do
		myconf="${myconf} --enable-${LISP}"
	done

	# remove xmaxima if no tk
	if use tk; then
		myconf="${myconf} --with-wish=wish"
	else
		myconf="${myconf} --with-wish=none"
		sed -i \
			-e '/^SUBDIRS/s/xmaxima//' \
			interfaces/Makefile.in || die "sed for tk failed"
	fi

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall emacsdir="${D}${SITELISP}/${PN}" || die "einstall failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	if use latex; then
		insinto "${MAXIMA_TEXMFDIR}"/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README.lisps || die
	dodir /usr/share/doc
	dosym /usr/share/${PN}/${PV}/doc /usr/share/doc/${PF}

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el
		# imaxima docs
		cd interfaces/emacs/imaxima
		insinto /usr/share/${PN}/${PV}/doc/imaxima
		doins ChangeLog NEWS README || die "installing imaxima docs failed"
		insinto /usr/share/${PN}/${PV}/doc/imaxima/imath-example
		doins imath-example/*.txt || die "installing imaxima docs failed"
	fi
}

pkg_preinst() {
	# some lisps do not read compress info files (bug #176411)
	for infofile in "${D}"/usr/share/info/*.bz2 ; do
		bunzip2 "${infofile}"
	done
	for infofile in "${D}"/usr/share/info/*.gz ; do
		gunzip "${infofile}"
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
