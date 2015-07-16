#!/usr/bin/env python
import sys
import socket
import shlex
from subprocess import Popen, PIPE
import time

local_hostname = socket.gethostname()
print "Hostname = "+local_hostname

# print("std out = \n"+out)

if (len(sys.argv) == 1):
    print "error. need an expected computer to track"
    exit(1)

expected_track = sys.argv[1]
print "expected computer to track: "+expected_track

while True:

    print "calling chronyc tracking..."
    cmd = "chronyc tracking"
    process = Popen(shlex.split(cmd), stdout=PIPE)
    out, err = process.communicate()
    exit_code = process.wait()

    for line in out.splitlines():
        if (line.startswith("Reference ID    :")):
            # print "found it"
            # print line
            splits = line.split(":")
            if (len(splits) > 0):
                ip_name_combo = splits[1]
                tracking_comp_name_with_extra_brace = ip_name_combo.split("(")[1]
                if (tracking_comp_name_with_extra_brace.startswith(")")):
                    print "error. no tracking found"
                    tracking_comp_name = "none"
                else:
                    tracking_comp_name = tracking_comp_name_with_extra_brace.split(")")[0]
                print "tracking: "+tracking_comp_name
            else:
                print "Error. length of splits = 0"

    if (tracking_comp_name == expected_track):
        result = "tracking correct computer: "+tracking_comp_name
        print result
    else:
        result = "NOT tracking the correct computer. tracking: "+tracking_comp_name+" Should be tracking: "+expected_track
        print result

        cmd = "rostopic pub -1 /vigir_foobar std_msgs/String \"data: \'"+ local_hostname+": chroncy tracking check: "+ result + "\'\""
        #print cmd


        print "Sending output via rostopic pub..."
        process = Popen(shlex.split(cmd), stdout=PIPE, stderr=PIPE)

        out, err = process.communicate()
        exit_code = process.wait()
        if (exit_code != 0):
            print "\nFailed to send output to /vigir_foobar. "+out, err

    time.sleep(30)
