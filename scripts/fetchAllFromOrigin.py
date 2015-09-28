#!/usr/bin/env python
import subprocess
import os
import glob
import re
import time
import sys
from subprocess import Popen
import pipes
import argparse

LOCAL_REPO_DIRECTORY = '/home/hector/thor/'
ROSBUILD_DIRECTORY = '/home/hector/thor/rosinstall/'

def parse():
    pattern  = ROSBUILD_DIRECTORY+"*.rosinstall"

    result = 0
    for index, script in enumerate(sorted(glob.glob(pattern))):
        with open (script, "r") as myfile:
            data=myfile.read()
        allFolders = re.findall("local-name: \S*", data)   
        allUris = re.findall("uri: \S*", data)
        
        for i in range(len(allFolders)):
            if ( allUris[i].find("external.torcrobotics.com") >= 0 ):
                print "Ignoring " + allFolders[i] + ": torcrobotics repo"
                continue
            folders = re.findall("\S*",allFolders[i])            
            local_folder = LOCAL_REPO_DIRECTORY + folders[2].replace(',','').replace(' ','')
            
            if(os.path.isdir(local_folder)):                          
                print "Now processing "+local_folder+" folder...."
                result = result | os.system("cd "+local_folder+";git fetch origin +refs/heads/*:refs/heads/* --prune")
                
    if (result != 0):
        os.system("ssmtp steinachim@gmx.de < /home/hector/error-fetch.msg")               
        result_str = "fail" 
    else:
        os.system("ssmtp steinachim@gmx.de < /home/hector/success-fetch.msg")
        result_str = "success"

    os.system("echo \"Last Fetch: `date` - "+result_str+"\" >> /home/hector/last_action.log")
                    
if __name__ == "__main__":
    parse()
