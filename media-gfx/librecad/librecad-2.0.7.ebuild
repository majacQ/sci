# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic qt4-r2 vcs-snapshot

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${PV/_/}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc tools 3d"

DEPEND="
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsvg:4
	dev-libs/boost
	dev-cpp/muParser
	media-libs/freetype"

RDEPEND="${DEPEND}"
S="${WORKDIR}/LibreCAD-${PV}"

src_prepare() {
	# currently RS_VECTOR3D causes an internal compiler error on GCC-4.8
	use 3d || sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro || die
}

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && dohtml -r librecad/support/doc/*
	insinto /usr/share/appdata
	doins unix/appdata/librecad.appdata.xml
	doicon librecad/res/main/"${PN}".png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
