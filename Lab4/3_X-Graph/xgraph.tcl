set ns [new Simulator]

$ns rtproto DV

# to show the simulation in ns2
set nf [open out.nam w]
$ns namtrace-all $nf

set nt [open trace.tr w]
$ns trace-all $nt


# open files according to endpoints
for {set a 0} {$a < 2} {incr a} {
    set f$a [open out$a.tr w]
}

# defining procedure
# declaration
proc finish {} {
global ns nf nt f0 f1
$ns flush-trace
close $nf
close $nt
close $f0
close $f1
exec nam out.nam &
exec awk -f throughput.awk trace.tr &
exit 0
}

# creating 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
# set n5 [$ns node]

$n0 color "blue"
$n4 color "blue"
$n1 color "red"
# $n5 color "red"

$n0 label "S1"
$n4 label "D1"
$n1 label "S2"
# $n5 label "D2"


$ns duplex-link $n0 $n2 10Mb 10ms DropTail  
$ns duplex-link $n1 $n2 10Mb 10ms DropTail  
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
# $ns duplex-link $n3 $n5 10Mb 10ms DropTail
 
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
# $ns duplex-link-op $n3 $n5 orient right-down

$ns color 2 red

# establishing tcp connection between n0 to n4 through n0
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$ns color 1 blue;
# generatting ftp traffic 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP 
$ftp set packet_size_ 1000
$ftp set rate_ 1mb

# 
# udp connection
# 

# establishing udp connection between n1 to n5
# set udp [new Agent/UDP]
# $ns attach-agent $n1 $udp
# set null [new Agent/LossMonitor]
# $ns attach-agent $n5 $null
# $ns connect $udp $null
# $udp set fid_ 2
# generatting cbr traffic 
# set cbr [new Application/Traffic/CBR]
# $cbr attach-agent $udp
# $cbr set type_ CBR 
# $cbr set packet_size_ 1000
# $cbr set rate_ 1mb
# $cbr set random_ false


proc record {} {
    global sink null f0 $f1
    set ns [Simulator instance]
    set time 0.5
    set now [$ns now]
    set bw0 [$sink set bytes_]
    set bw1 [$null set bytes_]
    puts $f0 "$now [expr $bw0/$time*8/1000000]"
    puts $f1 "$now [expr $bw1/$time*8/1000000]"
    $sink set bytes_ 0
    $null set bytes_ 0
    $ns at [expr $now+$time] "record"
}

# simulation start and end time 
# $ns at 1.0 "$cbr start"
# $ns at 2.0 "$cbr stop"

# simulation start and end time 
$ns at 1.0 "$ftp start"
$ns at 2.0 "$ftp stop"

$ns at 5.0 "finish"
$ns run
