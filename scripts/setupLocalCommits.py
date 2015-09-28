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

SERVER_REPO_DIRECTORY = '/home/hector/thor/'
LOCAL_REPO_DIRECTORY = os.environ['WORKSPACE_ROOT'] + '/'
ROSBUILD_DIRECTORY = os.environ['WORKSPACE_ROOT'] + '/rosinstall/'

def parse(hostname, reset):
    pattern  = ROSBUILD_DIRECTORY+"*.rosinstall"
    for index, script in enumerate(sorted(glob.glob(pattern))):
        with open (script, "r") as myfile:
            data=myfile.read()
            
        allUris = re.findall("uri: \S*", data)
        allFolders = re.findall("local-name: \S*", data)   
        
        for i in range(len(allFolders)):
            if ( allUris[i].find("external.torcrobotics.com") >= 0 ):
                print "Ignoring " + allFolders[i] + ": torcrobotics repo"
                continue
              
            folders = re.findall("\S*",allFolders[i])            
            local_folder = LOCAL_REPO_DIRECTORY + folders[2].replace(',','').replace(' ','')
            server_folder = SERVER_REPO_DIRECTORY + folders[2].replace(',','').replace(' ','')
            
            if(os.path.isdir(local_folder)):                          
                print "Now processing "+local_folder+" folder...."
                if(reset):
                    os.system("cd "+local_folder+"/.git; sed -i 's/remote = offline/remote = origin/g' config")
                    os.system("cd "+local_folder+";git remote remove offline")                    
                if len(hostname) > 0:
                    #p = subprocess.Popen(["git remote add vigir@"+hostname+":"+folder], cwd=folder)    
                    os.system("git config receive.denyCurrentBranch ignore")
                    os.system("cd "+local_folder+"; git remote add offline hector@"+hostname+":"+server_folder)
                    os.system("cd "+local_folder+"/.git; sed -i 's/remote = origin/remote = offline/g' config")
                    os.system("ssh-copy-id hector@turtlebot3.thor")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Setup machine to be able to push/pull to machine on local network", epilog=__doc__)
    parser.add_argument("hostname", default="", nargs="?", help="Hostname to use; defaults to aragorn")
    parser.add_argument("-r", "--reset", action="store_true", help="reconfigure computers if local commits have already been setup")
    args = parser.parse_args()
    parse(args.hostname, args.reset)
