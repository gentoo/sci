# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 ) # No 3.11 according to setup.py
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A module to call MATLAB from Python"
HOMEPAGE="https://github.com/mathworks/matlab-engine-for-python"

LICENSE="MathWorks"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist mirror"
