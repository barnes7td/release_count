require 'release_class'
require 'win32ole'
require 'excel_helper'

$e = WIN32OLE.connect('Excel.Application')
$e['Visible'] = true

rts_wb = $e.Workbooks('Release Tally Sheet.xlsx')
rts_wb.Activate

$rel = Release.new('6464', 'A')
