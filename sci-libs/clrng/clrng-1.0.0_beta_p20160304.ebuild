# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="../docs"
DOCS_CONFIG_NAME="clRNG.doxy"

inherit cmake docs

MY_PN="clRNG"

DESCRIPTION="A library for uniform random number generation in OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clRNG"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clMathLibraries/${MY_PN}.git"
	S="${WORKDIR}/${P}/src"
else
	COMMIT="4a16519ddf52ee0a5f0b7e6288b0803b9019c13b"
	SRC_URI="https://github.com/clMathLibraries/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${COMMIT}/src"
fi

LICENSE="BSD-2 BSD"
SLOT="0"

IUSE="+client test"

RDEPEND="
	virtual/opencl
	dev-util/intel-ocl-sdk
	dev-libs/boost
"
DEPEND="${RDEPEND}"

# The tests only get compiled to an executable named Test, which is not recogniozed by cmake.
# Therefore src_test() won't execute any test.
RESTRICT="test"

PATCHES=( "${FILESDIR}/clrng-allow-newer-gcc.patch" )

src_configure() {
	local mycmakeargs=(
		$(use_with client CLIENT)
		$(use_with test TEST)
	)
	cmake_src_configure
}

src_compile() {
	default
	docs_compile
}
