# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake rpm xdg

DESCRIPTION="Synchronize files from CERNBox EOS with your computer"

# Origin is classic owncloud-client, branded for CERN during compilation.
ORIGIN_PN="ownCloud"
BRANDED_P="cernbox"
BRANDED_PV="2.9.2"
BRANDED_REL="6339"
HOMEPAGE="https://cernbox.cern.ch/"
SRC_URI="https://download.owncloud.com/desktop/${ORIGIN_PN}/stable/${PV}/source/${ORIGIN_PN}-${PV}.tar.xz
	https://cernbox.cern.ch/cernbox/doc/Linux/repo/CentOS_7/src/${PN}-${BRANDED_PV}-${BRANDED_REL}.src.rpm
	https://cern.ch/ofreyerm/gentoo/cernbox/${PN}-${BRANDED_PV}-${BRANDED_REL}.src.rpm"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dolphin gnome-keyring nautilus test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/sqlite-3.4:3
	dev-libs/qtkeychain[gnome-keyring?,qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-fs/inotify-tools
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )"

DEPEND="${RDEPEND}
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)"

BDEPEND="
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules"

S=${WORKDIR}/${ORIGIN_PN}-${PV}

src_unpack() {
	rpm_src_unpack ${PN}-${BRANDED_PV}-${BRANDED_REL}.src.rpm || die "failed to extract branding RPM"
	mv ${PN%-*}-${BRANDED_PV}.${BRANDED_REL}/branding "${S}" || die "failed to extract branding"
}

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	if ! use nautilus; then
		pushd shell_integration > /dev/null || die
		cmake_comment_add_subdirectory nautilus
		popd > /dev/null || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
