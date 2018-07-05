#!/usr/bin/awk -f
BEGIN {
	OFS=" : "
	split(ARGV[2],lineIPs,",")
	ARGV[2]=""
	print "IP", "NAT"
}
{
  if ($0 ~ /^set security nat destination pool .*$/) {
    for (i in lineIPs) {
    	if ($8 ~ lineIPs[i]) {
    	  lineIPPools[lineIPs[i]]=$6;
      }
    }
  }
  if ($0 ~ /^set security nat destination rule-set .* rule .* then destination-nat pool .*$/) {
    rules[$12]=$8;
  }
  if ($0 ~ /^set security nat destination rule-set .* rule .* match destination-address .*$/) {
    nats[$8]=$11;
  }
}
END {
	for (lineIP in lineIPPools) {
	  print lineIP, nats[rules[lineIPPools[lineIP]]];
  }
}