# ios_messages_to_csv

ios_messages_to_csv is a short Ruby 1.9 script which reads iOS SMS backup files and converts them to CSV.

These files are only SQLite3 databases, so reading them is very straightforward.

## Usage

The SMS backup file is called "3d0d7e5fb2ce288813306e4d4636395e047a3d28". It may or may not have an extension (.mddata, .mdbackup). One Mac OS X it can be found in:

    /Users/<username>/Library/Application Support/MobileSync/Backup/<backup id>/

On Windows Vista/7, if you're into that sort of thing, it can be found in:

    /Users/<username>/AppData/Roaming/Apple Computer/MobileSync/Backup/<backup id>/

ios_messages_to_csv takes two command-line parameters. The first is the SMS backup file. The other is an optional CSV output file.

    ruby ios_messages_to_csv.rb 3d0d7e5fb2ce288813306e4d4636395e047a3d28 output.csv

When the output csv file is not specified, the CSV content is output to stdout.

## Compatibility

This has been tested with iOS 5.0.1 / iTunes 10.5.3 / Mac OS X 1.7.3 only.

Ruby 1.9 is required to use CSV, but this script can be used with Ruby 1.8 by replacing CSV with the FasterCSV gem.

## Futher Work

The address book is backed up in the file 31bb7ba8914766d4ba40d6dfb6113c8b614be442. This could be used to convert phone numbers to names.
