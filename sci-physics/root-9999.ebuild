# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/root/root-5.26.00-r4.ebuild,v 1.4 2010/07/06 15:59:37 bicatali Exp $

EAPI=3

PYTHON_DEPEND="python? 2"
ESVN_REPO_URI="https://root.cern.ch/svn/root/trunk/"

inherit versionator eutils qt4 subversion elisp-common fdo-mime python toolchain-funcs

DOC_PV=$(get_major_version)_$(get_version_component_range 2)
ROOFIT_DOC_PV=2.91-33
TMVA_DOC_PV=4

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="http://root.cern.ch/"
SRC_URI=""
