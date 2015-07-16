#!/usr/bin/env python
#/*********************************************************************
# * Software License Agreement (BSD License)
# *
# *  Copyright (c) 2013-2015, Team ViGIR ( TORC Robotics LLC, TU Darmstadt, 
# *  Virginia Tech, Oregon State University, Cornell University, and Leibniz University Hanover )
# *  All rights reserved.
# *
# *  Redistribution and use in source and binary forms, with or without
# *  modification, are permitted provided that the following conditions
# *  are met:
# *
# *   * Redistributions of source code must retain the above copyright
# *     notice, this list of conditions and the following disclaimer.
# *   * Redistributions in binary form must reproduce the above
# *     copyright notice, this list of conditions and the following
# *     disclaimer in the documentation and/or other materials provided
# *     with the distribution.
# *   * Neither the name of Team ViGIR, TORC Robotics, nor the names of its
# *     contributors may be used to endorse or promote products derived
# *     from this software without specific prior written permission.
# *
# *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# *  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# *  POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************/
# @TODO_ADD_AUTHOR_INFO
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
