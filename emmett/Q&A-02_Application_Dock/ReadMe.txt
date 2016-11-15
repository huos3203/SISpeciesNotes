The emmett command line tool includes a few options that you may be interested in:

o If you don't want to relaunch the Dock, use -no-kill

emmett add /Applications/MyApplication.app -no-kill

o When emmett tries to add an application, it checks that the application is not already in the Dock with the same path. If you want to remove any existing instance of the application in the Dock that would be at another path or under another name, use the -no-duplicate. It will compare application using their bundle-identifiers

emmett add /Applications/MyApplication.app -no-duplicate

o emmett can also be used to remove items from the Dock

emmett remove /Applications/MyApplication.app

or

emmett remove MyApplication

or

emmett remove -bundle-identifier com.mycompany.myapplication

or

emmett remove -regex myappli

