# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

MY_PN=FormCalc
MY_P=${MY_PN}-${PV}

DESCRIPTION="FormCalc can be used for automatic Feynman diagram computation."
HOMEPAGE="https://feynarts.de/formcalc"
SRC_URI="https://feynarts.de/formcalc/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form[threads]
	"
DEPEND="${RDEPEND}"
BDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form
	"
PATCHES=( "${FILESDIR}"/${PN}-9.9-compile.patch )

src_compile() {
	# remove shipped binaries
	rm bin/Linux-x86-64/* || die
	rm bin/Linux-x86-64-kernel2.6/* || die
	export DEST=Linux-x86-64
	./compile ${LDFLAGS} || die
}

src_install() {
	MMADIR=/usr/share/Mathematica/Applications
	# unversioned directory
	dosym ${MY_P} ${MMADIR}/${MY_PN}
	mv "${WORKDIR}/${MY_P}" "${ED}${MMADIR}" || die
	# switch to system form
	dosym `command -v form` ${MMADIR}/${MY_P}/Linux-x86-64/form
	dosym `command -v tform` ${MMADIR}/${MY_P}/Linux-x86-64/tform

	dodoc manual/*.pdf
}
