# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy/embassy-6.1.0.ebuild,v 1.2 2010/01/01 21:35:29 fauli Exp $

EAPI="4"

inherit emboss

DESCRIPTION="A meta-package for installing all EMBASSY packages (EMBOSS add-ons)"
SRC_URI=""

LICENSE+=" freedist"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+="
	=sci-biology/embassy-cbstools-1.0.0-r2
	=sci-biology/embassy-domainatrix-0.1.0-r5
	=sci-biology/embassy-domalign-0.1.0-r5
	=sci-biology/embassy-domsearch-0.1.0-r5
	=sci-biology/embassy-emnu-1.05-r7
	=sci-biology/embassy-esim4-1.0.0-r7
	=sci-biology/embassy-hmmer-2.3.2-r4
	=sci-biology/embassy-iprscan-4.3.1-r2
	=sci-biology/embassy-memenew-4.0.0-r1
	=sci-biology/embassy-mira-2.8.2-r2
	=sci-biology/embassy-mse-3.0.0
	=sci-biology/embassy-phylipnew-3.69
	=sci-biology/embassy-signature-0.1.0-r5
	=sci-biology/embassy-structure-0.1.0-r5
	=sci-biology/embassy-topo-2.0.0
	=sci-biology/embassy-vienna-1.7.2-r2"

DOCS=""

S="${WORKDIR}"

src_prepare() {
:
}

src_configure() {
:
}
