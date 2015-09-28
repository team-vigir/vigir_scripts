#!/bin/bash

set -e -u

option=${1:-none}

# ---------------------------------------------------------------------------

# Pull custom repos
repos=" \
$WORKSPACE_ROOT \
$WORKSPACE_ROOT/rosinstall/optional/custom \
$WORKSPACE_SCRIPTS \
$WORKSPACE_SCRIPTS/custom \
"

for repo in $repos
do
	if [ -d $repo ] && [ -d $repo/.git ]
	then
		echo "Updating Repository in $repo"
		cd $repo
		git pull
		echo
	fi
done

# ---------------------------------------------------------------------------

echo "Remove obsolete packages..."
$WORKSPACE_SCRIPTS/rm_obsolete_packages.sh
echo

#echo ">>> Checking package updates"
#./rosinstall/install_scripts/install_package_dependencies.sh
#echo

# ---------------------------------------------------------------------------

# Merge updates
cd $WORKSPACE_ROOT
echo ">>> Merging rosinstall files"
for file in $WORKSPACE_ROOT/rosinstall/*.rosinstall
do
	filename=$(basename ${file%.*})
	if [ -n "${WORKSPACE_MANG_NO_SIM:-}" ] && [ $filename == "thor_mang_simulation" ]
	then
		continue;
	else
		if [ ! "$option" = "--no-merge" ]
		then
			echo "Merging to workspace: '$filename'.rosinstall"
			wstool merge $file -y
		fi
	fi
done
echo


# ---------------------------------------------------------------------------

# Include user data
if [ -f ~/.torcuser ]
then
	# Include user data
	. ~/.torcuser

	# Create build folder if neccessary
	if [ ! -d "$WORKSPACE_ROOT/build" ]; then mkdir -v -p $WORKSPACE_ROOT/build; fi

	# Create expect file and run wstool stuff
	cat > $WORKSPACE_ROOT/build/thor-update_expect <<EOF
	spawn wstool update
	expect "Username for 'https://external.torcrobotics.com'"
	send "$TORC_USER\r\n"
	expect "Password for 'https://$TORC_USER@external.torcrobotics.com'"
	send "$TORC_PASS\r\n"
	interact
EOF

	# Run expect file
	cd $WORKSPACE_ROOT/src
	expect $WORKSPACE_ROOT/build/thor-update_expect

else
	wstool update

fi

