The InstallOrUpgrade sample project shows how to reproduce the pre/post install/upgrade mechanism of bundle packages with flat packages.

The preinstall.sh and postinstall.sh scripts will be run if the package is installed for the first time on the system.

The preugrade.sh and postupgrade.sh scripts will be run if the package had already been installed on the system.

Note: for testing purpose, you can use the --forget option of the pkgutils(1) command line tool to make the system believe a package is being installed for the first time.