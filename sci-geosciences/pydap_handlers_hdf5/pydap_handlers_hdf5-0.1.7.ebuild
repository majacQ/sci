# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="HDF5 file handler for Pydap Data Access Protocol server"
HOMEPAGE="http://pydap.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]
	>=dev-python/paver-1.0.4[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0[${PYTHON_USEDEP}]
	>=dev-python/pupynere-1.0.8[${PYTHON_USEDEP}]
	>=dev-python/arrayterator-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.0[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	paver generate_setup || die
	distutils-r1_python_prepare_all
}
