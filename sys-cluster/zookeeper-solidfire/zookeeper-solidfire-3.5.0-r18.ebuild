# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.1 2014/05/19 14:09:08 anarchy Exp $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize subversion

DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org/"
ESVN_REPO_URI="https://svn.apache.org/repos/asf/zookeeper/trunk@1547702"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~amd64"

## DEPENDENCIES ##
BOOST_VERSION=1.54.0-r1
JAVA_VERSION=7.2.4.7
DEPEND="dev-java/ant-core
	=dev-java/icedtea-solidfire-${JAVA_VERSION}
	=dev-libs/boost-solidfire-${BOOST_VERSION}
	dev-libs/libxml2
	dev-libs/log4cxx
	dev-util/cppunit
	dev-vcs/subversion"
RDEPEND="=dev-java/icedtea-solidfire-${JAVA_VERSION}"

## PATCHES ##
PDIR="${FILESDIR}/patches/${PVR}"
PATCHES=(
	"${PDIR}/case-120.patch"
	"${PDIR}/case-3869.patch"
	"${PDIR}/case-5569.patch"
	"${PDIR}/ZOOKEEPER-1167.patch"
	"${PDIR}/ZOOKEEPER-1520.patch"
	"${PDIR}/ZOOKEEPER-1366.patch"
	"${PDIR}/ZOOKEEPER-1626.patch"
)

INSTALL_FILES="{bin,classes,lib,test,${P}*.jar}"
CONFIGURED_JUTE="${S}/.configured_jute"
CONFIGURED_C="${S}/.configured_c"
CONFIGURED_ZKTREEUTIL="${S}/.configured_zktreeutil"
CONFIGURED_ZKPYTHON="${S}/.configured_zkpython"
COMPILED_JAVA="${S}/.compiled_java"
COMPILED_C="${S}/.compiled_c"
COMPILED_ZKTREEUTIL="${S}/.compiled_zktreeutil"
COMPILED_ZKPYTHON="${S}/.compiled_zkpython"
TESTED_JAVA="${S}/.tested_java"
TESTED_C="${S}/.tested_c"
INSTALLED_JAVA="${S}/.installed_java"
INSTALLED_C="${S}/.installed_c"
INSTALLED_ZKTREEUTIL="${S}/.installed_zktreeutil"
INSTALLED_ZKPYTHON="${S}/.installed_zkpython"

## Tests don't compile with latest compiler
RESTRICT=test

#-----------------------------------------------------------------------------
# PREPARE
#-----------------------------------------------------------------------------

src_prepare()
{
	versionize_src_prepare

	## Update log4j properties file
	props="${S}/conf/log4j.properties"
	sed -i -e "s|zookeeper.root.logger=INFO, CONSOLE|zookeeper.root.logger=INFO, CONSOLE, SYSLOGD|" ${props} || die

	# Add log4j SYSLOGD output
	echo ""                                                                                                  >> ${props}
	echo "#"                                                                                                 >> ${props}
	echo "# Log INFO level and above messages to SYSLOG"                                                     >> ${props}
	echo "#"                                                                                                 >> ${props}
	echo "log4j.appender.SYSLOGD=org.apache.log4j.net.SyslogAppender"                                        >> ${props}
	echo "log4j.appender.SYSLOGD.Threshold=INFO"                                                             >> ${props}
	echo "log4j.appender.SYSLOGD.SyslogHost=localhost"                                                       >> ${props}
	echo "log4j.appender.SYSLOGD.Facility=LOCAL0"                                                            >> ${props}
	echo "log4j.appender.SYSLOGD.layout=org.apache.log4j.PatternLayout"                                      >> ${props}
	echo "log4j.appender.SYSLOGD.layout.ConversionPattern=%X{hostname}zookeeper - %-5p [%t:%C{1}@%L] - %m%n" >> ${props}
}

#-----------------------------------------------------------------------------
# CONFIGURE
#-----------------------------------------------------------------------------

configure_jute()
{
	[[ -f ${CONFIGURED_JUTE} ]] && return
	[[ $(caller 0 | awk '{print $2}') == "src_configure" ]] || pre_configure

	einfo "Configuring Jute"
	pushd ${S} >/dev/null
	ant compile_jute || die
	popd >/dev/null

	touch ${CONFIGURED_JUTE}
}

configure_c()
{
	[[ -f ${CONFIGURED_C} ]] && return
	configure_jute

	einfo "Configuring C"
	pushd ${S}/src/c >/dev/null
	autoreconf -if || die
	versionize_src_configure
	popd >/dev/null

	touch ${CONFIGURED_C}

	[[ $(caller 0 | awk '{print $2}') == "src_configure" ]] || post_configure
}

configure_zktreeutil()
{
	[[ -f ${CONFIGURED_ZKTREEUTIL} ]] && return
	compile_c
	
	einfo "Configuring zktreeutil"
	pushd ${S}/src/contrib/zktreeutil >/dev/null

	append-cppflags "-I/usr/include/boost-solidfire-${BOOST_VERSION}"
	append-ldflags  "-L/usr/lib/boost-solidfire-${BOOST_VERSION}"

	autoreconf -if || die
	sed -i -e "s|#include <log4cxx/logger.h>|#include <log4cxx/logger.h>\n#include <unistd.h>|" \
		src/ZkAdaptor.cc || die

	sed -i -e "s|zookeeper_mt|zookeeper_mt-${MY_PVR}|g" 									 \
		   -e "s|-lzookeeper_mt-${MY_PVR}|-lzookeeper_mt-${MY_PVR} -Wl,-rpath,$(dirv lib)|g" \
		configure.ac || die

	sed -i -e "s|lzookeeper_mt|lzookeeper_mt-${MY_PVR}|g" \
		configure || die

	versionize_src_configure
	touch ${CONFIGURED_ZKTREEUTIL}
}

configure_zkpython()
{
	[[ -f ${CONFIGURED_ZKPYTHON} ]] && return
	configure_jute

	einfo "Configuring zkpython"
	sed -i -e 's|libraries=|runtime_library_dirs=["'$(dirv lib)'"],libraries=|' \
		   -e 's|zookeeper_mt|zookeeper_mt-'${MY_PVR}'|g'                         \
		   -e 's|version = "0.4"|version = "'${MY_PVR}'"|g'                       \
		${S}/src/contrib/zkpython/src/python/setup.py || die
	
	touch ${CONFIGURED_ZKPYTHON}
}

src_configure()
{
	configure_jute
	configure_c
}

#-----------------------------------------------------------------------------
# COMPILE
#-----------------------------------------------------------------------------

compile_java()
{
	[[ -f ${COMPILED_JAVA} ]] && return

	einfo "Compiling Java: compile"
	ant compile || die
		
	einfo "Compiling Java: jar"
	ant jar || die
		
	touch ${COMPILED_JAVA}
}

compile_c()
{
	[[ -f ${COMPILED_C} ]] && return
	configure_c

	einfo "Compiling C: make"
	pushd ${S}/src/c >/dev/null
	emake

	## BUG: TESTS DO NOT COMPILE WITH GCC-4.8.1
	#if [[ "${PLATFORM}" != "Darwin" ]]; then
	#    einfo "Compiling C: make zktest-st zktest-mt"
	#    emake zktest-st zktest-mt
	#fi

	popd >/dev/null

	touch ${COMPILED_C}
}

compile_zktreeutil()
{
	[[ -f ${COMPILED_ZKTREEUTIL} ]] && return
	configure_zktreeutil

	einfo "Compiling zktreeutil"
	pushd ${S}/src/contrib/zktreeutil >/dev/null
	emake
	popd >/dev/null
	
	touch ${COMPILED_ZKTREEUTIL}
}

compile_zkpython()
{
	[[ -f ${COMPILED_ZKPYTHON} ]] && return
	configure_zkpython
	compile_c

	einfo "Compiling zkpython"
	pushd ${S}/src/contrib/zkpython >/dev/null
   
	DISTUTILS_DEBUG=1 ant compile || die

	pushd ${S}/build/contrib/zkpython/lib.linux-x86_64-2.7 >/dev/null
	mv zookeeper.so zookeeper-${MY_PVR}.so || die
	popd >/dev/null

	touch ${COMPILED_ZKPYTHON}
}

src_compile()
{
	rm -rf ${S}/build || die
	compile_java
	compile_c
	compile_zktreeutil
	compile_zkpython
}

#-----------------------------------------------------------------------------
# TEST
#-----------------------------------------------------------------------------

test_java()
{
	[[ -f ${TESTED_JAVA} ]] && return
	
	compile_java
	einfo "Testing Java: ant test"
	ant test || die
	touch ${TESTED_JAVA}
}

test_c()
{
	[[ -f ${TESTED_C} ]] && return
	
	compile_java
	compile_c
	pushd ${S}/src/c >/dev/null
		
	if [[ "${PLATFORM}" != "Darwin" ]]; then
		einfo "Testing C: zktest-st"
		./zktest-st || die
		
		einfo "Testing C: zktest-mt"
		./zktest-mt || die
	fi

	popd >/dev/null

	touch ${TESTED_C}
}

src_test()
{
	test_java
	test_c
}

src_retest()
{
	rm -f ${TESTED_C} ${TESTED_JAVA} || die
	src_test
}

#-----------------------------------------------------------------------------
# INSTALL
#-----------------------------------------------------------------------------

install_java()
{
	[[ -f ${INSTALLED_JAVA} ]] && return
	compile_java

	einfo "Installing Java"

	insinto $(dirv opt)
	doins -r ${S}/conf ${S}/build/{lib,*.jar}
	mv $(idirv opt)/zookeeper-${PV}.jar $(idirv opt)/${PF}.jar || die

	## ZK scripts
	insinto $(dirv opt)/bin
	doins -r ${S}/bin/*.sh
	for f in $(/bin/ls $(idirv opt)/bin); do
		fname="$(dirv opt)/bin/$(basename ${f})"
		dosym "${fname}" /usr/bin/${f}-${MY_PVR}
		sed -i -e "/ZOOBIN=.*/d"                               \
			   -e "s|ZOOBINDIR=.*|ZOOBINDIR=/$(dirv opt)/bin|" \
			${D}/${fname} || die
	done

	## Set JAVA_HOME in zkEnv.sh
	sed -i -e "s|ZOOBINDIR=|JAVA_HOME=${JAVA_HOME}\nZOOBINDIR=|" \
		"$(idirv opt)/bin/zkEnv.sh" || die

	touch ${INSTALLED_JAVA}
}

install_c()
{
	[[ -f ${INSTALLED_C} ]] && return
	compile_c

	einfo "Installing C"
	pushd ${S}/src/c >/dev/null
	emake DESTDIR="${D}" install
	popd >/dev/null

	mv $(idirv bin)/cli_st-${MY_PVR} $(idirv bin)/zkcli_st-${MY_PVR} || die
	mv $(idirv bin)/cli_mt-${MY_PVR} $(idirv bin)/zkcli_mt-${MY_PVR} || die

	touch ${INSTALLED_C}
}

install_zktreeutil()
{
	[[ -f ${INSTALLED_ZKTREEUTIL} ]] && return
	compile_zktreeutil

	einfo "Installing zktreeutil"
	pushd ${S}/src/contrib/zktreeutil >/dev/null
	emake DESTDIR="${D}" install
	popd >/dev/null
	mv $(idirv bin)/load_gen-${MY_PVR} $(idirv bin)/zkload_gen-${MY_PVR} || die

	touch ${INSTALLED_ZKTREEUTIL}
}

install_zkpython()
{
	[[ -f ${INSTALLED_ZKPYTHON} ]] && return
	compile_zkpython

	einfo "Installing zkpython"
	insinto $(dir lib)/python2.7
	doins ${S}/build/contrib/zkpython/lib.linux-x86_64-2.7/zookeeper-${MY_PVR}.so

	touch ${INSTALLED_ZKPYTHON}
}

src_install()
{
	install_java
	install_c
	install_zktreeutil
	install_zkpython
	versionize_src_postinst
}
