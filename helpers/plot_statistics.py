#!/usr/bin/python
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
import yaml
import rosbag
import matplotlib.pyplot as plt
import sys
import numpy

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

if (len(sys.argv) == 2) and (sys.argv[1] == '--help'):
   print "Usage: plot_statistics file_name>  <start_time> <end_time> "
   print "  plot_bag 2015-01-15-10-13-41.bag  10.4 20.5"
   sys.exit(1)


file_name = '2015-01-15-10-13-41.bag'
if (len(sys.argv) > 1):
	file_name = sys.argv[1]

start_time = 0
end_time   = 999999999999.9

if (len(sys.argv) > 2):
        start_time = float(sys.argv[2])

if (len(sys.argv) > 3):
        end_time = float(sys.argv[3])


print "Read bag file ..."
bag = rosbag.Bag(file_name, 'r')

print "Get topic info..."
info_dict = yaml.load(bag._get_yaml_info())
print(info_dict['topics'])

print "Get list ..."
topic_list = []
cmd_msgs = 0
state_msgs = 0

cntrl_stats_msgs = []
interface_stats_msgs   = []
status_msgs=[]

for topic_info in info_dict['topics']:
        topic = topic_info['topic']
        topic_list.append(topic)
        if (topic == '/flor/controller/controller_statistics'):
                cntrl_stats_msgs = topic_info['messages']
        if (topic == '/flor/controller/interface_statistics'):
                interface_stats_msgs = topic_info['messages']
        if (topic == '/flor/controller/status'):
                status_msgs = topic_info['messages']

print topic_list

print "Message counts:"
print "  control   msgs="+str(  cntrl_stats_msgs 	)
print "  interface msgs="+str(  interface_stats_msgs 	)
print "  status    msgs="+str(  status_msgs 	)

print "Process messages ..."
time_base = -1;
jnt = 16

stats = ['mean', 'dev','min', 'max','count']
print "  Process joint command..."
t_i = [0 for x in xrange(cntrl_stats_msgs)]
robot_loop_timing = [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
robot_state_timing= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
filter_timing= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
robot_control_timing= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
robot_state_loop_timing= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
robot_control_loop_timing= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
control_latency= [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
sequence_latency = [[0 for x in xrange(cntrl_stats_msgs)] for x in xrange(len(stats))]
max_control_skip_count= [0 for x in xrange(cntrl_stats_msgs)]


pt = 0
for topic, msg, t0 in bag.read_messages(topics='/flor/controller/interface_statistics'):
        if (time_base < 0):
            time_base = msg.stamp.to_sec()
        t_i[pt] = (msg.stamp.to_sec() - time_base)
        robot_loop_timing[0][pt] = msg.robot_loop_timing.mean
        robot_loop_timing[1][pt] = msg.robot_loop_timing.std_dev
        robot_loop_timing[2][pt] = msg.robot_loop_timing.min
        robot_loop_timing[3][pt] = msg.robot_loop_timing.max
        robot_loop_timing[4][pt] = msg.robot_loop_timing.measurements

        control_latency[0][pt] = msg.control_latency.mean
        control_latency[1][pt] = msg.control_latency.std_dev
        control_latency[2][pt] = msg.control_latency.min
        control_latency[3][pt] = msg.control_latency.max
        control_latency[4][pt] = msg.control_latency.measurements

        sequence_latency[0][pt] = msg.sequence_latency.mean
        sequence_latency[1][pt] = msg.sequence_latency.std_dev
        sequence_latency[2][pt] = msg.sequence_latency.min
        sequence_latency[3][pt] = msg.sequence_latency.max
        sequence_latency[4][pt] = msg.sequence_latency.measurements

        pt = pt + 1
        #print(pt)
        
end_time = min(end_time, max(t_i))
print "Set end time ="+str(end_time)

fig_mode = plt.figure()
ax_mode = fig_mode.add_subplot(111)
ax_mode.plot(t_i,robot_loop_timing[3],'r',t_i,robot_loop_timing[2],'b',t_i,robot_loop_timing[0],'g')
ax_mode.axis([start_time, end_time,min(robot_loop_timing[2]), max(robot_loop_timing[3])])
ax_mode.set_ylabel('ms')
ax_mode.set_xlabel('time')
fig_mode.suptitle("Robot Loop Timing")

fig_mode = plt.figure()
ax_mode = fig_mode.add_subplot(111)
ax_mode.plot(t_i,control_latency[3],'r',t_i,control_latency[2],'b',t_i,control_latency[0],'g')
ax_mode.axis([start_time, end_time,min(control_latency[2]), max(control_latency[3])])
ax_mode.set_ylabel('delta')
ax_mode.set_xlabel('time')
fig_mode.suptitle("Control Latency")

fig_mode = plt.figure()
ax_mode = fig_mode.add_subplot(111)
ax_mode.plot(t_i,sequence_latency[3],'r',t_i,sequence_latency[2],'b',t_i,sequence_latency[0],'g')
ax_mode.axis([start_time, end_time,min(sequence_latency[2]), max(sequence_latency[3])])
ax_mode.set_ylabel('delta')
ax_mode.set_xlabel('time')
fig_mode.suptitle("Sequence Latency")


print "Show plot..."
plt.show()

print "Close bag!"
bag.close()



