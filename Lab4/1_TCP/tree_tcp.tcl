set ns [new Simulator]

# to show the simulation in ns2
set nf [open tree.nam w]
$ns namtrace-all $nf

# defining procedure
# declaration
proc finish {} {
global ns nf
$ns flush-trace
close $nf

exec nam tree.nam &
exit 0
}

# creating 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n3 10Mb 10ms DropTail
$ns duplex-link $n1 $n4 10Mb 10ms DropTail
 
$ns duplex-link-op $n0 $n1 orient left-down
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n3 orient left-down
$ns duplex-link-op $n1 $n4 orient right-down


$ns color 2 red

# establishing tcp connection between n0 to n1
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
# generatting ftp traffic 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP 
$ftp set packet_size_ 1000
$ftp set rate_ 1mb


# establishing tcp connection between n0 to n2
set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1
# generatting ftp traffic 
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP 
$ftp1 set packet_size_ 1000
$ftp1 set rate_ 1mb

# establishing tcp connection between n1 to n3
set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n1 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
$ns connect $tcp2 $sink2
# generatting ftp traffic 
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP 
$ftp2 set packet_size_ 1000
$ftp2 set rate_ 1mb

# establishing tcp connection between n1 to n4
set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n1 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
# generatting ftp traffic 
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp2
$ftp3 set type_ FTP 
$ftp3 set packet_size_ 1000
$ftp3 set rate_ 1mb

# simulation start and end time 
$ns at 0.0 "$ftp start"
$ns at 0.5 "$ftp stop"

$ns at 0.0 "$ftp1 start"
$ns at 0.5 "$ftp1 stop"

$ns at 0.0 "$ftp2 start"
$ns at 0.5 "$ftp2 stop"

$ns at 0.0 "$ftp3 start"
$ns at 0.5 "$ftp3 stop"

$ns at 5.0 "finish"
$ns run