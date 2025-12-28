#!/usr/bin/tclsh

set fp [open "test" r]
set file_text [read $fp]
close $fp
set lines [split $file_text "\n"]

set points {}
foreach line $lines {
    lappend points [split $line ","]
}

set circuits {}
set connected {}
set distances {}

foreach start_point $points {
    if {[lsearch -exact $connected $start_point]>=0} {
        continue
    }

    set start_point_idx [lsearch -exact $points $start_point]
    set point_distances {}
    foreach end_point [lreplace $points $start_point_idx $start_point_idx] {
        if {[dict exists $distances "$end_point,$start_point"]} {
            set distance [dict get $distances "$end_point,$start_point"]
        } else {
            set s_x [lindex $start_point 0]
            set s_y [lindex $start_point 1]
            set s_z [lindex $start_point 2]
            set e_x [lindex $end_point 0]
            set e_y [lindex $end_point 1]
            set e_z [lindex $end_point 2]
            set distance [expr {($s_x-$e_x)**2 + ($s_y-$e_y)**2 + ($s_z-$e_z)**2}]
        }
        lappend point_distances [list $end_point $distance]
        dict set distances "$start_point,$end_point" $distance
    }
    set point_distances [lsort -integer -index 1 $point_distances]
    set connect_to [lindex [lindex $point_distances 0] 0]
    set added_to_existing false
    foreach circuit $circuits {
        if {[lsearch -exact $circuit $connect_to]>=0} {
            set circuit_idx [lsearch $circuits $circuit]
            lappend circuit $start_point
            set circuits [lreplace $circuits $circuit_idx $circuit_idx $circuit]
            set added_to_existing true
            break
        }
    }
    if {!$added_to_existing} {
        lappend circuits [list $start_point $connect_to]
    }
    if {$start_point ni $connected} {
        lappend connected $start_point
    }
    if {$connect_to ni $connected} {
        lappend connected $connect_to
    }
}

proc compare_by_length {a b} {
    return [expr {[llength $b] - [llength $a]}]
}

set circuits [lsort -command compare_by_length $circuits]

set first_length [llength [lindex $circuits 0]]
set second_length [llength [lindex $circuits 1]]
set third_length [llength [lindex $circuits 2]]

puts [format "1- %s" [lindex $circuits 0]]
puts [format "2- %s" [lindex $circuits 1]]
puts [format "3- %s" [lindex $circuits 2]]
puts [format "%d * %d * %d = %d" $first_length $second_length $third_length [expr {$first_length * $second_length * $third_length}]]
