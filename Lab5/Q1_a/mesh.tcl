set ns [new Simulator]
$ns rtproto DV
set nf [open mesh.nam w]
$ns namtrace-all $nf
set nftr [open mesh.tr w]
$ns trace-all $nftr
set var [lindex $argv 0]

proc finish {} {
	global ns nf nftr
	$ns flush-trace
	close $nf
	exec nam mesh.nam &
	exec awk -f /home/shubham/Desktop/CNLabAll/CNLabAll/Lab5/rb/Q1_a/throughput.awk mesh.tr > var_mesh15_out &
	exit 0
}

for {set i 0} {$i < $var} {incr i} {
	set n($i) [$ns node]
}
for {set i 0} {$i < $var} {incr i} {
	for {set j 0} {$j < $var} {incr j} {
		if {($i<$j||$i>$j)&&[expr $i%2]==1} {
			$ns duplex-link $n($i) $n($j) 1Mb 10ms DropTail
		}
	}
}
for {set i 1} {$i < $var} {incr i} {
	if {[expr $i%2]!=0} {
		set udp($i) [new Agent/UDP]
		$ns attach-agent $n([expr ($i)]) $udp($i)
		set null($i) [new Agent/Null]
		$ns attach-agent $n([expr ($i)-1]) $null($i)
		$ns connect $udp($i) $null($i)
		set cbr($i) [new Application/Traffic/CBR]
		$cbr($i) attach-agent $udp($i)
		$cbr($i) set packetSize_ 500
		$cbr($i) set interval_ 0.005
	}
}

if ($var%2) {
	set udp($var+1) [new Agent/UDP]
 	$ns attach-agent $n([expr ($var%2)]) $udp($var+1)
 	set cbr($var+1) [new Application/Traffic/CBR]
	$cbr($var+1) attach-agent $udp($var+1)
	$cbr($var+1) set packetSize_ 500
	$cbr($var+1) set interval_ 0.005
	set null($var) [new Agent/Null]
	$ns attach-agent $n([expr ($var-1)]) $null($var)
	$ns connect $udp($var+1) $null($var)
	$ns  at 0.5 "$cbr($var+1) start"
 	
}
for {set i 0} {$i < $var} {incr i} {
	if {[expr $i%2]!=0} {
		$ns  at 0.5 "$cbr($i) start"
	}
}

for {set i 0} {$i < $var} {incr i} {
	if { [expr $i%2]!=0 } {
		$ns at 4.5 "$cbr($i) stop"
	}
}
$ns at 5.0 "finish"
$ns run
