# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2-utils

DESCRIPTION="A simple medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/MRIcroGL"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurolabusc/MRIcroGL.git"
EGIT_COMMIT="${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="<dev-lang/fpc-3.0.0
	dev-lang/lazarus"

src_compile() {
	lazbuild -B --lazarusdir="/usr/share/lazarus/" simplelaz.lpi || die
}

src_install() {
	dobin MRIcroGL

	insinto /usr/bin/shaders
	doins shaders/*.txt

	doicon -s scalable mricrogl.svg
	make_desktop_entry MRIcroGL MRIcroGL /usr/share/icons/hicolor/scalable/apps/mricrogl.svg
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
