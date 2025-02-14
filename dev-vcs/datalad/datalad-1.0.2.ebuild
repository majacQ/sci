# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Keep code, data, containers under control with git and git-annex"
HOMEPAGE="https://github.com/datalad/datalad"
#SRC_URI="https://github.com/datalad/datalad/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +downloaders +metadata +publish misc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	app-arch/p7zip
	app-arch/patool[${PYTHON_USEDEP}]
	dev-python/annexremote[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/iso8601[${PYTHON_USEDEP}]
	dev-python/looseversion[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wraps[${PYTHON_USEDEP}]
	dev-vcs/git-annex
	downloaders? (
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/keyrings-alt[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
	metadata? (
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/whoosh[${PYTHON_USEDEP}]
	)
	misc? (
		dev-python/argcomplete[${PYTHON_USEDEP}]
		dev-python/pyperclip[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
	publish? (
		dev-vcs/python-gitlab[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/httpretty[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"
# Also wants test dep:
# dev-python/types-requests
# dev-python/types-python-dateutil

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_datetimes.py::TestUnitTestMethodDecorator::test_method_decorator_works_on_unittest_kwarg_frozen_time
	tests/test_datetimes.py::TestUnitTestMethodDecorator::test_method_decorator_works_on_unittest_kwarg_frozen_time_with_func
	tests/test_datetimes.py::TestUnitTestMethodDecorator::test_method_decorator_works_on_unittest_kwarg_hello
)

python_test() {
	local -x DATALAD_TESTS_NONETWORK=1
	# see test groups in "tox.ini"
	epytest -k "not turtle and not slow and not usecase"
}
