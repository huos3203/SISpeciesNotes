on run
do shell script "open -n /Applications/mpv.app"
tell application "mpv" to activate
end run

on open theFiles
repeat with theFile in theFiles

end repeat
do shell script "open -na /Applications/mpv.app " & quote & (POSIX path of theFiles) & quote
tell application "mpv" to activate
end open

--
on run
do shell script "open -n /Applications/mpv.app"
tell application "mpv" to activate
end run
on open theFiles
display dialog theFiles
repeat with theFile in theFiles
end repeat
set a to "/Users/pengyucheng/Library/Developer/Xcode/DerivedData/SISpeciesNotes-axtwkgkpmpacrbdsutotqzseqpsr/Build/Products/Debug/ScaryBugsMac.app/Contents/Resources/BigBuck.m4v"
display dialog a
-- do shell script "open -na /Applications/mpv.app " & quote & (POSIX path of a) & quote
do shell script "open -na /Applications/mpv.app " & quote & (POSIX file a) & quote
tell application "mpv" to activate
end open
--