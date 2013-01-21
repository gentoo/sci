EAPI=4
inherit cmake-utils
inherit versionator

# MY_PN="hpx"
# MY_PV="${PV}"
# MY_P="${MY_PN}_${MY_PV}"
S="${WORKDIR}/${PN}_${PV}"

DESCRIPTION="HPX (High Performance ParalleX) is a general C++ runtime system for parallel and distributed applications of any scale."
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"
SRC_URI="http://stellar.cct.lsu.edu/files/hpx_${PV}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.48"
RDEPEND="${DEPEND}"

# DEPEND="razorqt-base/libqtxdg
#         x11-libs/libX11
#         x11-libs/libXcomposite
#         x11-libs/libXcursor
#         x11-libs/libXdamage
#         x11-libs/libXfixes
#         x11-libs/libXrender
#         x11-libs/qt-core:4
#         x11-libs/qt-dbus:4
#         x11-libs/qt-gui:4
#         !<razorqt-base/razorqt-meta-0.5.0
#         !x11-wm/razorqt"
# RDEPEND="${DEPEND}"

# src_configure() {
#         local mycmakeargs=(
#                 -DSPLIT_BUILD=On
#                 -DMODULE_LIBRAZORQT=On
#                 -DMODULE_LIBRAZORQXT=On
#                 -DMODULE_LIBRAZORMOUNT=On
#                 -DMODULE_ABOUT=On
#                 -DMODULE_X11INFO=On
#         )
#         cmake-utils_src_configure
# }

src_configure() {
    export CMAKE_BUILD_TYPE=Release
    cmake-utils_src_configure
}

# src_compile() {
#     echo "....................-----------------------"
#     # cmake-utils_src_make Release
#     cmake-utils_src_compile Release
# }



# src_configure() {
#     econf --with-posix-regex
# }

# src_install() {
#     emake DESTDIR="${D}" install

#     dodoc FAQ NEWS README
#     dohtml EXTENDING.html ctags.html
# }

