import os, sys, csv, math
from operator import itemgetter, attrgetter
import socket

def parseWMCTRLOutput(filename):
	#print "parsing",filename
	
	result = []
	
	lines = open(filename, 'r').readlines()

	#for each line in the file
	for line in lines:
		config = line[0:line.find(host_name)+len(host_name)].replace(" ",",")
		while config.find(",,") != -1:
			config = config.replace(",,",",")
		tokens = config.split(",")
		if len(tokens) >= 6:			
			#print tokens
			window_name = line[line.find(host_name)+len(host_name)+1:].rstrip("\n")
			#print window_name
			#print "window geometry:",tokens[2],tokens[3],tokens[4],tokens[5]
			result.append([window_name,tokens[2],tokens[3],tokens[4],tokens[5]])
		
	return result


#entry point for the test function. runs if running this by itself
if __name__ == '__main__':
	global host_name
	#print "parsing file and saving in data structure"
	host_name = socket.gethostname()
	#print socket.gethostname()
	#print sys.argv
	if len(sys.argv) == 2:
		window_config = parseWMCTRLOutput(sys.argv[1])
		print "#!/bin/bash"
		print 
		print "# If you need to reposition new windows, this is the format used by wmctrl:"
		print "#   wmctrl -r <window_name> -e \'0,<offset x>,<offset y>,<width>,<height>\'"
		print "# you can generate the input script with the current window configuration by doing"
		print "#   wmctrl -lG > <output>"
		for window in window_config:
			print
			print "echo \'Setting up "+window[0]+"\'"
			print "wmctrl -r \'"+window[0]+"\' -e '0,"+str(window[1])+","+str(int(window[2])-67)+","+str(window[3])+","+str(window[4])+"\'"
	else:
		print "[ERROR] invalid number of arguments"
		print 
		print "format:"
		print "   python process_wmctrl_output.py <input>"
		print "   python process_wmctrl_output.py <input> > <output>"
		print
		print "To generate the input file for this script, run:"
		print "   wmctrl -lG > <file_name>" 
