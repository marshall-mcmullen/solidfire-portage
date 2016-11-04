# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: marshall
# Purpose: 
#

if [[ -z ${_ZOOKEEPER_ECLASS} ]]; then
_ZOOKEEPER_ECLASS=1

inherit subversion solidfire-libs
EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install src_test pkg_preinst

zookeeper-solidfire_src_unpack()
{
	subversion_src_unpack
}

zookeeper-solidfire_src_prepare()
{
	subversion_src_prepare

	# Set ivy path to not be /root/.ivy or else we get a sandbox violation
	sed -i -e 's|<property name="ivy.home" value="${user.home}/.ant"|<property name="ivy.home" value="'${WORKDIR}'/ant"|g' \
		build.xml

	# Prepare Jute
	ant compile_jute || die

	# Prepare C code
	pushd src/c
	eautoreconf #autoreconf -if || die
	popd

	# Update log4j properties file
	props="${S}/conf/log4j.properties"
	sed -i -e "s|zookeeper.root.logger=INFO, CONSOLE|zookeeper.root.logger=INFO, CONSOLE, SYSLOGD|" ${props} || die

	# Add log4j SYSLOGD output
	{
		echo ""
		echo "#"
		echo "# Log INFO level and above messages to SYSLOG"
		echo "#"
		echo "log4j.appender.SYSLOGD=org.apache.log4j.net.SyslogAppender"
		echo "log4j.appender.SYSLOGD.Threshold=INFO"
		echo "log4j.appender.SYSLOGD.SyslogHost=localhost"
		echo "log4j.appender.SYSLOGD.Facility=LOCAL0"
		echo "log4j.appender.SYSLOGD.layout=org.apache.log4j.PatternLayout"
		echo "log4j.appender.SYSLOGD.layout.ConversionPattern=%X{hostname}zookeeper - %-5p [%t:%C{1}@%L] - %m%n"

	} >> ${props}
	
	solidfire-libs_src_prepare
}

#-----------------------------------------------------------------------------
# CONFIGURE
#-----------------------------------------------------------------------------

zookeeper-solidfire_src_configure()
{
	einfo "Configure C: make"
	pushd src/c
	econf
	popd
}

#-----------------------------------------------------------------------------
# COMPILE
#-----------------------------------------------------------------------------

zookeeper-solidfire_src_compile()
{
	# Java
	{
		einfo "Compiling Java: compile"
		ant compile || die
		
		einfo "Compiling Java: jar"
		ant jar || die
	}
	
	# C
	{
		einfo "Compiling C: make"
		pushd src/c
		emake
		
		#einfo "Compiling C: make zktest-st zktest-mt"
		#emake zktest-st zktest-mt
		popd
	}
}

#-----------------------------------------------------------------------------
# INSTALL
#-----------------------------------------------------------------------------

zookeeper-solidfire_src_install()
{
	# Java
	{
		einfo "Installing Java"
		doins -r ${S}/conf ${S}/build/{lib,*.jar}
		mv ${DP}/zookeeper-${PV}.jar ${DP}/lib/${PF}.jar || die
		
		local bin
		for bin in $(find ${S}/bin/*.sh); do
			newbin ${bin} $(basename ${bin} .sh)${PS}.sh
		done
	}

	# C
	{
		einfo "Installing C"
		pushd src/c
		emake DESTDIR="${D}" install
		popd

		mv ${DP}/bin/cli_st${PS} ${DP}/bin/zkcli_st${PS} || die
		mv ${DP}/bin/cli_mt${PS} ${DP}/bin/zkcli_mt${PS} || die
	}
}

zookeeper-solidfire_pkg_preinst()
{
	subversion_pkg_preinst
	solidfire-libs_pkg_preinst
}

#-----------------------------------------------------------------------------
# TEST
#-----------------------------------------------------------------------------

zookeeper-solidfire_src_test()
{
	# Java
	ant test || die

	# C
	{
		pushd src/c
	
		einfo "Testing C: zktest-st"
		./zktest-st || die
		
		einfo "Testing C: zktest-mt"
		./zktest-mt || die
		
		popd
	}
}


fi
