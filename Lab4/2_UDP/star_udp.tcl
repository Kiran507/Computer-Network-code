set ns [new Simulator]

$ns color 2 red

# to show the simulation in ns2
set nf [open star.nam w]
$ns namtrace-all $nf

set nt [open star_trace.tr w]
$ns trace-all $nt


# defining procedure
# declaration
proc finish {} {
global ns nf nt
$ns flush-trace
close $nf
close $nt
exec nam star.nam &
exit 0
}

# creating 7 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
# 
#               n1              n2
#                       
#                       n0                    
# 
#               n3              n4
#
# nodes created but not linked

# linking all the nodes to create a star topology
# providing 3 different parameters 
# 1 => bandwidth (10Mb), 
# 2 => delay (10ms), 
# 3 => type of queue (DropTail)

$ns duplex-link $n1 $n0 10Mb 20ms DropTail  
$ns duplex-link $n2 $n0 10Mb 20ms DropTail
$ns duplex-link $n3 $n0 10Mb 20ms DropTail
$ns duplex-link $n0 $n4 100Mb 20ms DropTail 


# to drop the packages
# $ns queue-limit $n0 $n4 5

# 
#               n1        n2
#                  \    /
#                    n0 
#                  /    \
#               n3        n4
#
# nodes are linked but the direction is not yet specified 
 
$ns duplex-link-op $n1 $n0 orient right-down
$ns duplex-link-op $n2 $n0 orient left-down
$ns duplex-link-op $n3 $n0 orient right-up
$ns duplex-link-op $n4 $n0 orient left-up

# op stands for different options for the direction
# topology created 

# $ns duplex-link-op $n0 $n4 queuePos 1


# establishing udp connection between n1 to n4 through n0
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp $null
$udp set fid_ 2
# generatting cbr traffic 
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR 
$cbr set packet_size_ 1000
$cbr set rate_ 1mb


# establishing udp connection between n2 to n4 through n0
set udp1 [new Agent/UDP]
$ns attach-agent $n2 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n4 $null1
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

$ns at 0.0 "$cbr1 start"
$ns at 1.0 "$cbr1 stop"

# establishing udp connection between n3 to n4 through n0
set udp2 [new Agent/UDP]
$ns attach-agent $n3 $udp2
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp2 $null
# generatting cbr traffic 
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR 
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb

$ns at 0.0 "$cbr2 start"
$ns at 1.0 "$cbr2 stop"

$ns at 10.0 "finish"
$ns run