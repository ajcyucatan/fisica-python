#!/bin/bash

pwd

function program_is_installed {
	local return_=1
	type $1 >/dev/null 2>&1 || { local return_=0; }
	echo "$return_"
}

function echo_pass {
	printf "\e[32m✔ ${1}"
	printf "\033\e[0m"
}

function echo_fail {
	printf "\e[31m✘ ${1}"
	printf "\033\e[0m"
}

function echo_if {
	if [ $1 == 1 ]; then
		echo_pass $2
	else
		echo_fail $2
	fi
}

which python
echo "pip $(echo_if $(program_is_installed pip))"
echo "conda $(echo_if $(program_is_installed conda))"

if [ $(program_is_installed conda) == 1 ]; then
	conda -V
	conda activate
	conda info --envs
	pip -V
	while true
	do
		read -r -p "Create a new dedicated dev-env? [Y/n]" input
		case $input in
			[yY][eE][sS]|[yY])
				conda env create -f env.yml python=3.7
				conda info --envs
				conda activate instance # $name='' > env.yml
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
else
	cd ~
	ls
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
fi

# 1. CHECAR SI EXISTE CONDA
#	TRUE -> 2. PREGUNTAR SI QUIERE CREAR AMBIENTE
#		TRUE -> 3. YML
#		FALSE -> 3. WHILE READ TXT
#	FALSE -> 3. INSTALAR DEPENDENCIAS APT-GET Y WGET
#			4. SI EL SISTEMA ES 64 O 32 BITS
#			5. COSAS DEL PATH Y SOURCE BASH
#			6. PREGUNTAR SI QUIERE CREAR AMBIENTE
#				TRUE -> 7. YML
#				FALSE -> 7.WHILE READ TXT
# 4/8. ABRIR JUPYTERLAB CON SESION EN PWD

# Miniconda path input >> ~/.bashrc
cwd=$(pwd)
export PATH=$cwd/miniconda3/bin:$PATH >> ~/.bashrc
source ~/.bashrc
#bash /anaconda/install.sh -y

while read requirement; do conda install --yes $requirement || pip install $requirement; done < rqmts.txt

conda init
config --set auto_activate_base True

#conda env export > env.yml

#actualizar pip
#pip --version
pip install -r rqmts.txt

conda_bin="$miniconda_path/conda-bin"
echo "Installing dev-env for $miniconda_path..."
mkdir "$conda_bin"

ln -s "$miniconda_path/bin/conda" "$conda_bin/conda"
ln -s "$miniconda_path/bin/activate" "$conda_bin/activate"
ln -s "$miniconda_path/bin/deactivate" "$conda_bin/deactivate"

echo " " >> ~/.bashrc
echo "# conda bin" >> ~/.bashrc
echo export PATH=\"$conda_bin:\$PATH\" >> ~/.bashrc

echo "# conda env" >> ~/.bash_aliases
echo "alias activate='source activate'" >> ~/.bash_aliases
echo "alias deactivate='source deactivate; export PATH=\$(conda ..deactivate)'" >> ~/.bash_aliases

#source ~/.bashrc
#source ~/.bash_aliases

echo "Done, you are ready to go!"
# Abrir Jupyter en la carpeta 'ipynbs' la primera notebook
