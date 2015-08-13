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

def parse(reset):
    pattern  = ROSBUILD_DIRECTORY+"*.rosinstall"
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
                if(reset):
                    os.system("cd "+local_folder+";git config --bool core.bare false")
                else:
                    os.system("cd "+local_folder+";git config --bool core.bare true");
                #os.system("cd " + local_folder + "; git checkout master; git branch -d NO_COMMIT_BRANCH; git push origin :NO_COMMIT_BRANCH");
                
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Setup machine to be able to push/pull to machine on local network", epilog=__doc__)
    parser.add_argument("-r", "--reset", action="store_true", help="reconfigure computers if local commits have already been setup")
    args = parser.parse_args()
    parse(args.reset)
