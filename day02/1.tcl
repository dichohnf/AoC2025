#!/usr/bin/tclsh

set fp [open "input" r]
set file_text [read $fp]
close $fp
set file_text [string range $file_text 0 end-1]

set pairs [split $file_text ","]
set start_values {}
set end_values {}
foreach pair $pairs {
    set pair [split $pair "-"]
    lappend start_values [lindex $pair 0]
    lappend end_values [lindex $pair 1]
}

set length [llength $start_values]

set sum 0
for {set idx 0} {$idx<$length} {incr idx} {
    for {set value [lindex $start_values $idx]} {$value<=[lindex $end_values $idx]} {incr value} {
        set value_length [string length $value]
        if {[expr {($value_length%2)==0}]} {
            if {[expr {([string range $value 0 [expr {($value_length/2)-1}]])==([string range $value [expr {$value_length/2}] end])}]} {
                incr sum $value
            }
        }
    }
}

puts $sum
