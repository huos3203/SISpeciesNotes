#!/bin/sh

foundPackage=`/usr/sbin/pkgutil --volume "$3" --pkgs=$INSTALL_PKG_SESSION_ID`

if test -n "$foundPackage"; then

	# It's an upgrade

	/bin/sh ./preupgrade.sh

else

	# It's a clean install

	## For Mac OS X 10.5 ##

	if [ -z "$SHARED_INSTALLER_TEMP" ]; then

		/bin/echo "INSTALL" > $INSTALLER_TEMP/.install.$INSTALL_PKG_SESSION_ID

	fi

	## End For Mac OS X 10.5 ##

	/bin/sh ./preinstall.sh

fi

exit 0