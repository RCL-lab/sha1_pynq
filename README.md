# sha1_pynq

To build all project files you can run at command line

`vivado -source build_all.tcl ` 

from the project home directory.

or from vivado application tcl tab
you can move to project folder and run

`source build_all.tcl`

Scripts tested on Vivado 2017.4

Link that explains message padding :
https://www.ipa.go.jp/security/rfc/RFC3174EN.html#4

Before running the notebook:  
You will need to install the bitstring module which requires an internet connection.  
Login to the pynq and type the following:  
$ pip install bitstring  
or  
$ pip3 install bitstring  

Running the notebook:  
After logging into the Pynq, navigate to the jupyter_notebooks directory  
$ cd jupyter_notebooks  
Next, clone this repository  
$ git clone https://github.com/RCL-lab/sha1_pynq.git  
Open a web browser and type in ip address of the board and login  
All of the folders in the jupyter_notebooks directory will be there

Obtaining the IP Adress:
https://pynq.readthedocs.io/en/latest/getting_started.html#configuring-pynq  
Scroll down to section 'Opening a USB Serial Terminal'

##### Useful Links:
[Pynq-Getting Started Web Page](https://pynq.readthedocs.io/en/latest/getting_started.html)

[Pynq-Z1 Setup Guide](https://pynq.readthedocs.io/en/latest/getting_started/pynq_z1_setup.html)

[Setup Vivado](https://pynq.readthedocs.io/en/latest/overlay_design_methodology/board_settings.html)

[Overlay Tutorial](https://pynq.readthedocs.io/en/latest/overlay_design_methodology/overlay_tutorial.html)
