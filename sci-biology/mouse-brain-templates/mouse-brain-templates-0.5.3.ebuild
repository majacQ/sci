# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="A collection of mouse brain templates in NIfTI format"
HOMEPAGE="https://github.com/IBT-FMI/mouse-brain-templates_generator"
SRC_URI="
	https://resources.chymera.eu/distfiles/${P}.tar.xz
	hires? ( https://resources.chymera.eu/distfiles/${PN}HD-${PV}.tar.xz )
	"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="hires"

RDEPEND=""
DEPEND=""

pkg_pretend() {
	if use hires; then
		CHECKREQS_DISK_BUILD="4G"
		CHECKREQS_DISK_USR="4G"
		CHECKREQS_DISK_VAR="8G"
	else
		CHECKREQS_DISK_BUILD="500M"
	fi
	check-reqs_pkg_pretend
}

# We disable this phase to not check requirements twice.
pkg_setup() { :; }

src_install() {
	insinto "/usr/share/${PN}"
	doins *
	if use hires; then
		cd "../${PN}HD-${PV}"
		doins *
	fi
}
