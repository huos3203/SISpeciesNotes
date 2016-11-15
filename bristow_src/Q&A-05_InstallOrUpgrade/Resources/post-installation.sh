#!/bin/sh

foundPackage=`/usr/sbin/pkgutil --volume "$3" --pkgs=$INSTALL_PKG_SESSION_ID`

## For Mac OS X 10.5 ##

if [ -z "$SHARED_INSTALLER_TEMP" ]; then

	if [ -f $INSTALLER_TEMP/.install.$INSTALL_PKG_SESSION_ID ]; then

		foundPackage=""

		/bin/rm $INSTALLER_TEMP/.install.$INSTALL_PKG_SESSION_ID

	fi
fi

## End For Mac OS X 10.5 ##

if test -n "$foundPackage"; then

	# It's an upgrade

	/bin/sh ./postupgrade.sh

else

	# It's a clean install

	/bin/sh ./postinstall.sh

fi

exit 0