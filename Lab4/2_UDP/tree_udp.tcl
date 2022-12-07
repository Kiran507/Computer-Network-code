set ns [new Simulator]

$ns color 2 red

set nf [open tree.nam w]
$ns namtrace-all $nf

set nt [open tree_trace.tr w]
$ns trace-all $nt

proc finish {} {
global ns nf nt
$ns flush-trace
close $nf
close $nt
exec nam tree.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


$ns duplex-link $n0 $n1 10Mb 20ms DropTail  
$ns duplex-link $n0 $n2 10Mb 20ms DropTail
$ns duplex-link $n1 $n3 10Mb 20ms DropTail
$ns duplex-link $n1 $n4 10Mb 20ms DropTail 

$ns duplex-link-op $n0 $n1 orient left-down
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n3 orient right-down
$ns duplex-link-op $n1 $n4 orient left-down

# establishing udp connection between n0 to n1
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n1 $null
$ns connect $udp $null
$udp set fid_ 2
# generatting cbr traffic 
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR 
$cbr set packet_size_ 1000
$cbr set rate_ 1mb

# establishing udp connection between n0 to n2
set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1
# generatting cbr traffic 
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR 
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb

# simulation start and end time 
$ns at 0.0 "$cbr start"
$ns at 1.0 "$cbr stop"

$ns at 1.0 "$cbr1 start"
$ns at 2.0 "$cbr1 stop"

# establishing udp connection between n1 to n3
set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp2 $null
# generatting cbr traffic 
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR 
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb

$ns at 1.0 "$cbr2 start"
$ns at 2.0 "$cbr2 stop"

# establishing udp connection between n1 to n4
set udp3 [new Agent/UDP]
$ns attach-agent $n1 $udp3
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp3 $null
# generatting cbr traffic 
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR 
$cbr3 set packet_size_ 1000
$cbr3 set rate_ 1mb

$ns at 2.0 "$cbr3 start"
$ns at 3.0 "$cbr3 stop"

$ns at 10.0 "finish"
$ns run