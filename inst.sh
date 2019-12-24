#!/bin/bash

pwd
echo "Installing dependencies for Conda..."
sudo apt-get update -y
sudo apt-get install build-essential libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 -y
sudo apt-get install wget -y
echo "Now we are installing Conda..."
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	FILE=`mktemp`; sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -q0 $FILE && bash $FILE; rm $FILE
else
	FILE=`mktemp`; sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86.sh -q0 $FILE && bash $FILE; rm $FILE
fi
echo $PATH

cwd=$(pwd)
export PATH=$cwd/miniconda3/bin:$PATH >> ~/.bashrc
source ~/.bashrc
#bash /anaconda/install.sh -y

while true
	do
		read -r -p "Create a new dedicated dev-env? [Y/n]" input
		case $input in
			[yY][eE][sS]|[yY])
				conda env create -f env.yml python=3.7
				conda info --envs
				conda activate instance
				;;
			[nN][oO]|[nN])
				echo "No"
				while read requirement
					do
						conda install --yes $requirement || pip install $requirement
					done < rqmts.txt
				;;
			*)
				echo "Invalid input..."
		esac
	done

echo "Done, you are ready to go!"
# Abrir Jupyter en la carpeta 'ipynbs' la primera notebook
