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
# Check all indexes of the arrays
for {set idx 0} {$idx<$length} {incr idx} {
    # For each range i check all the values
    for {set value [lindex $start_values $idx]} {$value<=[lindex $end_values $idx]} {incr value} {
        set value_length [string length $value]
        #For each value I check all substring of max length value_length/2
        for {set value_idx 0} {$value_idx<[expr {$value_length/2}]} {incr value_idx} {
            set substring_length [expr {$value_idx+1}]
            if {[expr {($value_length % $substring_length)!=0}]} {
                continue
            }
            set substrings_number [expr {$value_length/$substring_length}]
            set substring [string range $value 0 $value_idx]
            set all_substrings_matches 1
            # For each substring (no overlapping) of length substring_length of the value I check the eqaulity with the first substring
            for {set substring_idx 1} {$substring_idx<$substrings_number} {incr substring_idx} {
                set substring_to_check [string range $value [expr {$substring_idx*$substring_length}] [expr {(($substring_idx +1)*$substring_length)-1}]]
                if {$substring_to_check ne $substring} {
                    set all_substrings_matches 0
                    break
                }
            }
            if {$all_substrings_matches} {
                incr sum $value
                puts $value
                break
            }
        }
    }
}

puts $sum
