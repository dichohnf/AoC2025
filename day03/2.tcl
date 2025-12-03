#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set sum 0
foreach line $lines {
    set substring [string range $line [expr {[string length $line]-12}] end]
    for {set idx [expr {[string length $line]-13}]} {$idx>=0} {incr idx -1} {
        set val [string index $line $idx]
        for {set jdx 0} {$jdx<12} {incr jdx} {
            if {$val>=[string index $substring $jdx]} {
                set tmp [string index $substring $jdx]
                set substring [string replace $substring $jdx $jdx $val]
                set val $tmp
            } else {
                break
            }
        }
    }
    incr sum $substring
}
puts $sum