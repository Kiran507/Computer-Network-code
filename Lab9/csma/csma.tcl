# Author: Atyant Yadav

# Setup Simulator
set ns [new Simulator]
LanRouter set debug_ 0
# Set initial values
set opt(n) 5
set opt(r) 0.1Mb
set opt(nc) 1Mb
set opt(cd) 0

# Command line instructions for running the script
proc usage {} {
    global argv0
    puts "Usage: $argv0 \[-n NumberOfNodes\]  \[-nc NetworkCapacity\] \[-r TrafficRate\] \[-cd EnableCollisionDetectionOrNot\] \n"
    exit 1
}

# Get opt parameters
proc getopt {argc argv} {
    global opt
    lappend optlist n r cd
    if {$argc < 4} usage
    for {set i 0} {$i < $argc} {incr i} {
        set arg [lindex $argv $i]
        if {[string range $arg 0 0] != "-"} continue
        set name [string range $arg 1 end]
        set opt($name) [lindex $argv [expr $i+1]]
    }
}

getopt $argc $argv

# Set different colors for different data flow
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# Open the trace files
set file1 [open out1.tr w]
$ns trace-all $file1

# Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Define a finish procedure
proc finish {} {
    global ns nf file1
    $ns flush-trace
    close $nf
    close $file1
    exec nam out.nam &
    exec awk -f //home/mysql106120124/Desktop/CN/Lab9/csma/throughput.awk out1.tr > throughput_out &
    exec awk -f //home/mysql106120124/Desktop/CN/Lab9/csma/overhead.awk out1.tr > overhead_out &
    exec awk -f //home/mysql106120124/Desktop/CN/Lab9/csma/plr.awk out1.tr > plr_out &
    # exec awk -f //home/mysql106120124/Desktop/CN/Lab9/csma/fair.awk out1.tr > fair_out &
    exit 0
}

# Create nodes
set num $opt(n)
for {set i 0} {$i <= $num} {incr i} {
    set node($i) [$ns node]
    lappend nodelist $node($i)
}

# Create LAN Connection between nodes according to CD preference
if {$opt(cd) == "1"} {
    set lan0 [$ns newLan $nodelist $opt(nc) 30ms LL Queue/DropTail MAC/Csma Channel]
} else {

    #set lan0 [$ns make-lan $nodelist $opt(nc) 30ms LL Queue/DropTail Mac/Sat/UnlottedAloha Channel]
    set lan0 [$ns newLan $nodelist $opt(nc) 30ms LL Queue/DropTail Mac/Sat/UnlottedAloha Channel]
}

# Create CBR Traffic with UDP Connection
for {set i 1} {$i <= $num} {incr i} {
    # Setup a UDP Connection
    set tcp($i) [new Agent/TCP]
    $ns attach-agent $node($i) $tcp($i)

    set sink($i) [new Agent/TCPSink]
    $ns attach-agent $node(0) $sink($i)
    $ns connect $tcp($i) $sink($i)

    # Create a CBR Traffic source and attach to udp0
    set ftp($i) [new Application/FTP]
    $ftp($i) set packet_size_ 1024
    $ftp($i) set rate_ $opt(r)
    $ftp($i) attach-agent $tcp($i)

    $tcp($i) set fid_ [expr ($i%3)+1]


    # Schedule events for CBR agents
    $ns at 0.1 "$ftp($i) start"
    $ns at 5.5 "$ftp($i) stop"
}

# Call the finish procedure
$ns at 6.0 "finish"


$ns run
