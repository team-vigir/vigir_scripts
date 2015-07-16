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
import numpy as np

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

if (len(sys.argv) == 2) and (sys.argv[1] == '--help'):
   print "Usage: plot_bag file_name> <\"csv joint_list\"> <start_time> <end_time> "
   print "  plot_bag 2015-01-15-10-13-41.bag  \"23, 24\" 10.4 20.5"
   print "    set joint_list to \"-1\" to plot all upper body joints"
   sys.exit(1)


file_name = 'log.bag'
if (len(sys.argv) > 1):
	file_name = sys.argv[1]

joints = range(16,28) + range(0,3)
if (len(sys.argv) > 2):
	print "Specify list of joint indices:"
	test = map( int, sys.argv[2].split(',') )	
	if (len(test) == 1) and (test[0] < 0):
		print "Use default joint list"
	else:
		joints = test
print "Joint list to plot:"
print joints

start_time = 0
end_time   = 999999999999.9

if (len(sys.argv) > 3):
	start_time = float(sys.argv[3])

if (len(sys.argv) > 4):
	end_time = float(sys.argv[4])


print "Read bag file ..."
bag = rosbag.Bag(file_name, 'r')

print "Get topic info..."
info_dict = yaml.load(bag._get_yaml_info())
print(info_dict['topics'])

print "Get list ..."
topic_list = []
cmd_msgs = 0
state_msgs = 0

state_msgs = []
cmd_msgs   = []
cntrl_msgs = []
mode_msgs  = []
robot_msgs = []
raw_msgs   = []
actuator_state_msgs=[]

for topic_info in info_dict['topics']:
        topic = topic_info['topic']
        topic_list.append(topic)
        if (topic == '/flor/controller/atlas_state'):
                state_msgs = topic_info['messages']
        if (topic == '/flor/controller/joint_command'):
                cmd_msgs = topic_info['messages']
        if (topic == '/flor/controller/joint_control'):
                cntrl_msgs = topic_info['messages']
        if (topic == '/flor/controller/mode'):
                mode_msgs = topic_info['messages']
        if (topic == '/flor/controller/robot_status'):
                robot_msgs = topic_info['messages']
        if (topic == '/flor/controller/raw_actuator'):
                raw_msgs = topic_info['messages']
                
        if (topic == '/flor/controller/actuator_state'):
                actuator_state_msgs = topic_info['messages']

print topic_list

print "Message counts:"
print "  state msgs="+str(  state_msgs 	)
print "  raw   msgs="+str(    raw_msgs 	)
print "  cmd   msgs="+str(   cmd_msgs 	)
print "  cntrl msgs="+str(   cntrl_msgs )
print "  mode  msgs="+str(   mode_msgs 	)
print "  robot msgs="+str(   robot_msgs )
print "  actuator_state="+str(   actuator_state_msgs )

print "Process messages ..."
time_base = -1;
jnt = 16


print "  Process joint command..."
t_d = [0 for x in xrange(cmd_msgs)] 
q_d = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
dq_d = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
ddq_d = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
effort_d = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
pid_cmd = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
ff_const = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]
friction_comp = [[0 for x in xrange(cmd_msgs)] for x in xrange(len(joints))]

pt = 0
for topic, msg, t0 in bag.read_messages(topics='/flor/controller/joint_command'):
        if (time_base < 0):
            time_base = msg.header.stamp.to_sec()
        t_d[pt] = (msg.header.stamp.to_sec() - time_base)
        #print msg
        for ndx, jnt in enumerate(joints):
                q_d[ndx][pt]   = msg.position[jnt]
                dq_d[ndx][pt]  = msg.velocity[jnt]
                ddq_d[ndx][pt] = msg.acceleration[jnt]
                pid_cmd[ndx][pt]  = msg.pid_cmd[jnt]
                ff_const[ndx][pt] = msg.ff_const[jnt]

                effort_d[ndx][pt] = msg.effort[jnt]
                friction_comp[ndx][pt] = msg.friction_comp[jnt]
        pt = pt + 1
        #print(pt)
        
print "  Process atlas state ..."
t = [0 for x in xrange(state_msgs)] 
q = [[0 for x in xrange(state_msgs)] for x in xrange(len(joints))]
dq = [[0 for x in xrange(state_msgs)] for x in xrange(len(joints))]
effort = [[0 for x in xrange(state_msgs)] for x in xrange(len(joints))]

pt = 0
for topic, msg, t0 in bag.read_messages(topics='/flor/controller/atlas_state'):
        if (time_base < 0):
            time_base = msg.header.stamp.to_sec()
        t[pt] = (msg.header.stamp.to_sec() - time_base)
        for ndx, jnt in enumerate(joints):
                q[ndx][pt] = msg.position[jnt]
                dq[ndx][pt]=msg.velocity[jnt]
                effort[ndx][pt]=msg.effort[jnt]
        pt = pt + 1
   

end_time = min(end_time, max(t))
print "Set end time ="+str(end_time)

print "  Process joint_control ..."
t_s = [0 for x in xrange(cntrl_msgs)] 
q_s = [[0 for x in xrange(cntrl_msgs)] for x in xrange(len(joints))]

pt = 0
for topic, msg, t0 in bag.read_messages(topics='/flor/controller/joint_control'):
        if (time_base < 0):
            time_base = msg.header.stamp.to_sec()
        t_s[pt] = (msg.header.stamp.to_sec() - time_base)
        for ndx, jnt in enumerate(joints):
                q_s[ndx][pt] = msg.position[jnt]
        pt = pt + 1
   
plot_raw = False
if (raw_msgs):
	plot_raw = True
	print "  Process raw actuator sensing ..."
	t_raw = [0 for x in xrange(raw_msgs)] 
	q_raw = [[0 for x in xrange(raw_msgs)] for x in xrange(len(joints))]
	dq_raw = [[0 for x in xrange(raw_msgs)] for x in xrange(len(joints))]

	pt = 0
	for topic, msg, t0 in bag.read_messages(topics='/flor/controller/raw_actuator'):
        	t_raw[pt] = (msg.header.stamp.to_sec() - time_base)
	        for ndx, jnt in enumerate(joints):
        	        q_raw[ndx][pt]   = msg.position[jnt]
        	        dq_raw[ndx][pt]  = msg.velocity[jnt]
	        pt = pt + 1


if (robot_msgs):
    print "  Process robot status ..."
    t_robot = [0 for x in xrange(robot_msgs)]
    desired_pressure = [0 for x in xrange(robot_msgs)]
    supply_pressure  = [0 for x in xrange(robot_msgs)]

    pt = 0
    for topic, msg, t0 in bag.read_messages(topics='/flor/controller/robot_status'):
        t_robot[pt] = (msg.stamp.to_sec() - time_base)
        #desired_pressure[pt]   = msg.pump_desired_pressure
        supply_pressure[pt]    = msg.pump_supply_pressure
        pt = pt + 1

    fig_pressure = plt.figure()
    ax_pressure = fig_pressure.add_subplot(111)
    ax_pressure.plot(t_robot,desired_pressure,'r', t_robot, supply_pressure,'b')
    ax_pressure.axis([start_time, end_time,0, max([max(desired_pressure), max(supply_pressure)])])
    ax_pressure.set_ylabel('psi')
    ax_pressure.set_xlabel('time')
    fig_pressure.suptitle("Supply Pressure")


if (mode_msgs):
    print "  Process control mode ..."
    t_mode      =     [0 for x in xrange(mode_msgs)]
    mode_cmd    = [0 for x in xrange(mode_msgs)]
    mode_robot  = [0 for x in xrange(mode_msgs)]


    pt = 0
    for topic, msg, t0 in bag.read_messages(topics='/flor/controller/mode'):
        t_mode[pt] = (msg.header.stamp.to_sec() - time_base)
        mode_cmd[pt]   = msg.bdi_commanded_behavior
        mode_robot[pt] = msg.bdi_current_behavior
        pt = pt + 1
    fig_mode = plt.figure()
    ax_mode = fig_mode.add_subplot(111)
    ax_mode.plot(t_mode,mode_cmd,'r',t_mode, mode_robot,'b')
    ax_mode.axis([start_time, end_time,0, max(mode_cmd)+1])
    ax_mode.set_ylabel('Mode')
    ax_mode.set_xlabel('time')
    fig_mode.suptitle("BDI Control Mode")


  
t_act = [0 for x in xrange(actuator_state_msgs)]
psi_pos  = [[0 for x in xrange(actuator_state_msgs)] for x in xrange(len(joints))]
psi_neg  = [[0 for x in xrange(actuator_state_msgs)] for x in xrange(len(joints))]
flow_dmd = [[0 for x in xrange(actuator_state_msgs)] for x in xrange(len(joints))]
effort_act  = [[0 for x in xrange(actuator_state_msgs)] for x in xrange(len(joints))]
pump_supply  = [0 for x in xrange(actuator_state_msgs)]
pump_inlet   = [0 for x in xrange(actuator_state_msgs)]

pt = 0
for topic, msg, t0 in bag.read_messages(topics='/flor/controller/actuator_state'):
      if (time_base < 0):
          time_base = msg.header.stamp.to_sec()
      t_act[pt] = (msg.header.stamp.to_sec() - time_base)
      pump_supply[pt] = msg.pump_supply_pressure
      pump_inlet[pt]  = msg.pump_inlet_pressure
      for ndx, jnt in enumerate(joints):
              psi_pos[ndx][pt] = msg.actuator_data[jnt].psi_pos
              psi_neg[ndx][pt] = msg.actuator_data[jnt].psi_neg
              flow_dmd[ndx][pt] = msg.actuator_data[jnt].estimated_flow_demand
              effort_act[ndx][pt] = msg.actuator_data[jnt].effort
      pt = pt + 1

print " Joints "
print joints
print "   Plots ..."


for ndx, jnt in enumerate(joints): 
  fig = plt.figure()
  ax = fig.add_subplot(711)
  ax.plot(t_d,q_d[ndx],'r',t,q[ndx],'b',t_raw,q_raw[ndx],'g')
  #ax.set_xlabel('time')
  ax.set_ylabel('q')
  ax.axis([start_time, end_time,min(min(q_d[ndx]),min(q[ndx])), max(max(q_d[ndx]),max(q[ndx]))])
  ax = fig.add_subplot(712)
  ax.plot(t_d,dq_d[ndx],'r',t,dq[ndx],'b', t_raw,dq_raw[ndx],'g')
  #ax.set_xlabel('time')
  ax.set_ylabel('dq')
  ax.axis([start_time, end_time,min(min(dq_d[ndx]),min(dq[ndx])), max(max(dq_d[ndx]),max(dq[ndx]))])
  ax = fig.add_subplot(713)
  ax.plot(t_d,ddq_d[ndx],'r')
  #ax.set_xlabel('time')
  ax.set_ylabel('ddq')
  ax.axis([start_time, end_time,min(ddq_d[ndx]), max(ddq_d[ndx])])
  ax = fig.add_subplot(714)
  ax.plot(t_d,pid_cmd[ndx],'r')
  #ax.set_xlabel('time')
  ax.set_ylabel('pid_cmd')
  ax.axis([start_time, end_time,min(pid_cmd[ndx]), max(pid_cmd[ndx])])
  ax = fig.add_subplot(715)
  ax.plot(t_d,ff_const[ndx],'r')
  ax.set_ylabel('servo')
  ax.axis([start_time, end_time,min(ff_const[ndx]), max(ff_const[ndx])])
  ax = fig.add_subplot(716)
  ax.plot(t_d,q_d[ndx],'r', t_s, q_s[ndx],'b')
  ax.set_ylabel('offset')
  ax.axis([start_time, end_time,min([min(q_d[ndx]),min(q_d[ndx])]), max([max(q_s[ndx]), max(q_s[ndx])])])
  if (plot_raw):
    ax = fig.add_subplot(717)
    ax.plot(t_raw,q_raw[ndx],'g', t, q[ndx],'b')
    ax.set_xlabel('time')
    ax.set_ylabel('actuator')
    ax.axis([start_time, end_time,min([min(q_raw[ndx]),min(q[ndx])]), max([max(q_raw[ndx]),max(q[ndx])])])
  fig.suptitle("Joint "+str(jnt))


  #offset_calc = numpy.interp(t, t_raw, q_raw[ndx]) - numpy.interp(t,t,q[ndx])
  #fig_offset = plt.figure()
  #ax_offset = fig_offset.add_subplot(111)
  #ax_offset.plot(t, offset_calc,'b')
  #ax_offset.set_xlabel('time')
  #ax_offset.set_ylabel('offset')
  #ax_offset.axis([start_time, end_time,min(offset_calc), max(offset_calc)])
  #fig_offset.suptitle("Joint "+str(jnt)+" Offset")

  fig_effort = plt.figure()
  ax_pressure = fig_effort.add_subplot(111)
  ax_pressure.plot(t_d,effort_d[ndx],'r', t, effort[ndx],'b')
  ax_pressure.axis([start_time, end_time,min([min(effort_d[ndx]), min(effort[ndx])]), max([max(effort_d[ndx]), max(effort[ndx])])])
  ax_pressure.set_ylabel('effort')
  ax_pressure.set_xlabel('time')
  fig_effort.suptitle("Joint "+str(jnt)+" Effort")

  fig_actuator = plt.figure()
  ax_actuator = fig_actuator.add_subplot(121)
  ax_actuator.plot(t_act,psi_pos[ndx],'r', t_act, psi_neg[ndx],'b')
  ax_actuator.axis([start_time, end_time,min([min(psi_pos[ndx]), min(psi_neg[ndx])]), max([max(psi_pos[ndx]), max(psi_neg[ndx])])])
  ax_actuator.set_ylabel('psi')
  ax_actuator.set_xlabel('time')
  ax_actuator = fig_actuator.add_subplot(122)
  ax_actuator.plot(t_act,flow_dmd[ndx],'g')
  ax_actuator.axis([start_time, end_time,min(flow_dmd[ndx]), max(flow_dmd[ndx])])
  ax_actuator.set_ylabel('flow')
  ax_actuator.set_xlabel('time')
  fig_actuator.suptitle("Joint "+str(jnt)+" Actuator State")

  fig_friction = plt.figure()
  ax_friction = fig_friction.add_subplot(111)
  ax_friction.plot(t_d,friction_comp[ndx],'r')
  ax_friction.axis([start_time, end_time,min([min(friction_comp[ndx]), min(friction_comp[ndx])]), max([max(friction_comp[ndx]), max(friction_comp[ndx])])])
  ax_friction.set_ylabel('friction_comp')
  ax_friction.set_xlabel('time')
  fig_friction.suptitle("Joint "+str(jnt)+" Friction")

  fig_position_offset= plt.figure()
  ax_position_offset = fig_position_offset.add_subplot(111)
  ax_position_offset.plot(t_d,q_d[ndx],'r',t,q[ndx],'b',t_raw,q_raw[ndx],'g',t_s, q_s[ndx],'c')
  ax_position_offset.axis([start_time, end_time,min(min(q_d[ndx]),min(q[ndx]),min(q_raw[ndx]),min(q_s[ndx])), max(max(q_d[ndx]),max(q[ndx]),max(q_raw[ndx]),max(q_s[ndx]))])
  fig_position_offset.suptitle("Joint "+str(jnt)+"  positions")

  error_encoder_calc = np.interp(t_d,t_d,q_d[ndx]) - np.interp(t_d, t, q[ndx])
  error_actuator_calc = np.interp(t_s,t_s,q_s[ndx]) - np.interp(t_s, t_raw, q_raw[ndx])

  print "shape=",error_actuator_calc.shape
  print "len=",len(list(error_actuator_calc.transpose()))
  print "len t_s=",len(t_s)

  fig_position_error= plt.figure()
  ax_position_error = fig_position_error.add_subplot(111)
  ax_position_error.plot(t_d,error_encoder_calc.ravel().tolist(),'b')
  ax_position_error.plot(t_s,error_actuator_calc.ravel().tolist(),'g')
  #ax_position_error.axis([start_time, end_time, min(error_encoder_calc.min(),error_actuator_calc.min()), max(error_encoder_calc.max(),error_actuator_calc.max())])
  fig_position_error.suptitle("Joint "+str(jnt)+"  errors")

print "Show plot..."
plt.show()

print "Close bag!"
bag.close()



