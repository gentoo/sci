# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit python-single-r1 git-r3

DESCRIPTION="flexible package manager supporting mutiple package version"
HOMEPAGE="https://spack.io/"
# we need the .git folder during runtime for command
# $ spack pkg
EGIT_REPO_URI="https://github.com/spack/spack"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-vcs/git
"

src_prepare() {
	sed -e "s:^#!/bin/sh:#!/usr/bin/env ${EPYTHON}:" \
	-i bin/spack || die

	default
}

src_test() {
	local -x SPACK_ROOT="${S}"
	local -x PATH="${S}/bin:${PATH}"
	${EPYTHON} bin/spack test -k "not ci and \
		not compiler_bootstrap and \
		not test_prs_update_old_api and \
		not test_first_accessible_path and \
		not test_get_stage_root_in_spack"  || \
		die "tests failed for ${EPYTHON}"
}

src_install() {
	dodir /opt/spack
	cp -r "${S}"/. "${ED}"/opt/spack || die

	doenvd "${FILESDIR}"/99spack
}

pkg_postinst() {
	elog "Spack has been installed to /opt/spack ."
	elog "To load spack into your environment, run"
	elog "\t . /opt/spack/share/spack/setup-env.sh"
}
