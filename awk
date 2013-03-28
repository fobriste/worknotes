#cool awk shit

awk '{print substr($4,2,length($4)-2)}' /etc/drweb/users.conf | sort 

#check Qmail delivery status for user

/from <user@address.com/ { start=1; mid=substr($9,0,index($9,":")-1); print 
$1 " " $2 " " $3 " NEW MSG " mid " FROM:  " $13 }
/starting delivery/ { if(start == 1 && $11 == mid) { delivery[$9]=$9; 
print "\t" $1 " " $2 " " $3 " DELIVERY " $9 " of mid " $11 " TO " $14} }
/delivery/ { if(start == 1 && $8 in delivery ) { print "\t\t" $1 " " $2 " " 
$3 " " $8 " " $9 " " $10 " " $11} }
/end msg/ { if(mid == $9) start=0 }

#this gives top senders

BEGIN {
arr[1]="pleskhomework.com"
arr[2]="dsfsaserfgast.com"
arr[3]="a.bigtools.com"
arr[4]="b.bigtoosl.com"
}
{
/(Jan 25|Jan 26|Jan 27|Jan 28|Jan 29|Jan 30|Jan 31).*from <.*@.*>/
  inarr=0; idx = index($13,"@")+1; idx2 = index($13,">"); dist = length($13) - 
idx; dom = substr($13,idx,dist);
  for(x in arr) {
    if(dom == arr[x]) {
      inarr=1
    }
  }
  if (inarr==1) {
    print  $13
  }
}

# domains not using rackspace dns
#
for i in `cat list`; do dig soa $i | awk '!/^;/ && /SOA/ {print}' | awk -v dm=`echo $i`  '$5 !~ /ns.rackspace.com/ {print dm}'; done

# sum total open files by process 
#

lsof -p<process id> | awk '$5 ~ /REG/ {c++;print $9} END {print c " Total files open"}'

#without showing files:
lsof -p<process id> | awk '$5 ~ /REG/ {c++} END {print c " Total files open"}'

#sending per user
awk '/qmail.*info msg.*from.*richardsonhealth.com/ {user[$13]+=$11} END { for (i in user) print i, "sent", user[i], "bytes."}' maillog

# getting true free memory out of sar
sar -r | awk 'FREE = $3+$7-$6 {print $1,$2,"free memory",FREE/1024,"mb"}'

# total transfer out apache access log
awk '{ total += $10 } END { print "total transfer out " total*1073741824 "G" }' access_log.processed

# unique errors in the error log
awk '/Fatal/ {print substr($0, index($0,$9)) }' /var/log/httpd/error_log | sort | uniq 

# Max memory usage during the day
sar -r | awk '!/memused/ && !/Aver/ {printf "%4.2f Mb memory used at %s %s\n", ($4-$6-$7)/1024, $1,$2 }' | sort -n | tail -1

#Actual memory usage from sar
LANG=C sar -r | awk '!/memused/ && !/Aver/ {printf "%s memory used = %4.1f mb\n", $1, ($3-$5-$6)/1024}'
#or
for a in `ls /var/log/sa/sa[0-9]*` ; do LANG=C sar -r -f $a | awk '/Aver/  {printf "%s memory used = %4.1f mb\n", $1 ,($3-$6-$5)/1024}' ; done


# aggrigate cpu usage or others in top
top -b -n1 | awk '!/%/ { arr[$12] += $10 } END { for (i in arr) print arr[i],"\t",i }' | sort -rn | head

# I don't like using top for this, here's with ps and memory usage:
ps aux | awk '!/USER/ { arr[$11] += $6 } END {for (i in arr) print arr[i]/1024,"M","\t",i }' | sort -rn | grep -v '^0'

#Where where the failure notices delieved first
for mail in `qmHandle -R | grep -B4 fail | awk '/^[[:digit:]]/ {print $1}'` ; do qmHandle -m$mail | awk '/Delivered/ {print $2}' | sed 's/[[:digit:]]*-//' ; done | sort | uniq -c | sort -n

#usefull stuff out of the ps report in rs-sysmon
#$3 = cpu $4 = memory 
awk '$1 !~/^USER|^201/ && $4 > 0 { arr[$11] += $4 } END { for (i in arr) print arr[i],"\t",i }' ps.log  | sort -rn | head 

#cpu time by virtual host 
/etc/init.d/httpd fullstatus | awk '/GET|POST/ { arr1[$12] += $5 ; arr2[$12] += 1} END { for (i in arr1) print arr1[i],"\t",i,"in \t" arr2[i],"process(es)." }' | sort -n
