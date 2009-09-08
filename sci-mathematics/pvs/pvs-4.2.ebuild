# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="PVS is a verification system written in Common Lisp"
HOMEPAGE="http://pvs.csl.sri.com/"
SRC_URI="http://pvs.csl.sri.com/download-open/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="doc"

RDEPEND="|| ( app-editors/emacs app-editors/xemacs )
		!x86? ( dev-lisp/sbcl ) x86? ( dev-lisp/cmucl )"

DEPEND="${RDEPEND}
		doc? ( app-text/texlive
				app-text/ghostscript-gpl )"

src_unpack() {
	unpack ${A}

	EPATCH_SOURCE="${FILESDIR}/${PV}" EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" epatch

	ln -s ../sum.tex ./doc/user-guide/sum.tex
	emake -C doc/release-notes clean
	rm doc/release-notes/pvs-release-notes.pdf
}

src_compile() {
	econf || die "econf failed"
	case $(tc-arch ${CTARGET}) in
		"x86")
			CMULISP_HOME="/usr" emake || die "emake failed"
			;;
		*)
			SBCLISP_HOME="/usr" emake -j1 || die "emake failed"
			;;
    esac
	bin/relocate && ./pvsio no_test

	if use doc; then
		emake -j1 -C doc/language || die "emake language doc failed"
		emake -j1 -C doc/prover || die "emake prover doc failed"
		emake -j1 -C doc/release-notes || die "emake release-notes doc failed"
		emake -j1 -C doc/user-guide || die "emake user-guide doc failed"
	fi
}

src_install() {
	rm -R bin/relocate emacs/emacs19
	mkdir tex
	mv pvs-tex.sub pvs.sty tex/
	mv Examples examples
	mkdir -p "${D}"/usr/share/pvs
	mv bin emacs examples lib tex wish "${D}"/usr/share/pvs/
	sed -i -e "s,^PVSPATH=.*$,PVSPATH=/usr/share/pvs," pvs
	sed -i -e "s,^PVSPATH=.*$,PVSPATH=/usr/share/pvs," pvsio
	cp pvs pvsio "${D}"/usr/share/pvs/
	dobin pvs pvsio
	dodoc INSTALL LICENSE NOTICES README

	if use doc; then
		mv doc/PVSio-2.d.pdf pvsio-reference-manual.pdf
		mv doc/language/language.pdf pvs-language-reference.pdf
		mv doc/prover/prover.pdf pvs-prover-guide.pdf
		mv doc/release-notes/pvs-release-notes.pdf pvs-release-notes.pdf
		mv doc/user-guide/user-guide.pdf pvs-system-guide.pdf
		dodoc pvsio-reference-manual.pdf pvs-language-reference.pdf \
			pvs-prover-guide.pdf pvs-release-notes.pdf pvs-system-guide.pdf
	fi
}

