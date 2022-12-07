set ns [new Simulator]

# to show the simulation in ns2
set nf [open star.nam w]
$ns namtrace-all $nf

# defining procedure
# declaration
proc finish {} {
global ns nf
$ns flush-trace
close $nf

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
#                      n0                     
# 
#               n3              n4
#
# nodes created but not linked

# linking all the nodes to create a star topology
# providing 3 different parameters 
# 1 => bandwidth (10Mb), 
# 2 => delay (10ms), 
# 3 => type of queue (DropTail)

$ns duplex-link $n1 $n0 10Mb 15ms DropTail  
$ns duplex-link $n2 $n0 10Mb 15ms DropTail
$ns duplex-link $n3 $n0 10Mb 15ms DropTail
$ns duplex-link $n4 $n0 10Mb 15ms DropTail 




# to drop the packages
# $ns queue-limit $n0 $n6 5

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

# $ns duplex-link-op $n0 $n6 queuePos 1

$ns color 2 red

# establishing tcp connection between n1 to n4 through n0
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
# generatting ftp traffic 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP 
$ftp set packet_size_ 1000
$ftp set rate_ 1mb


# establishing tcp connection between n2 to n4 through n0
set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n2 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1
# generatting ftp traffic 
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP 
$ftp1 set packet_size_ 1000
$ftp1 set rate_ 1mb

# establishing tcp connection between n3 to n4 through n0
set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n3 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
# generatting ftp traffic 
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP 
$ftp2 set packet_size_ 1000
$ftp2 set rate_ 1mb


# simulation start and end time 
$ns at 0.0 "$ftp start"
$ns at 1.0 "$ftp stop"

$ns at 0.0 "$ftp1 start"
$ns at 1.0 "$ftp1 stop"

$ns at 0.0 "$ftp2 start"
$ns at 1.0 "$ftp2 stop"

$ns at 10.0 "finish"
$ns run