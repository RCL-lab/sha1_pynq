# sha1_pynq

This project creates sha1 overlay hardware design for Pynq-Z1 and Pynq-Z2 boards and provide python code to interface and control the hardware design.

## 1- Building the project  (optional)

If you want to get and use pre-built overlay hardware designs you can skip to section 2.

### Building overlay hardware design

To regenerate overlay hardware design for Pynq-Z1 board run this command on your terminal from the project folder.

`cd boards/Pynq-Z1/ && make`

for Pynq-Z2 board

`cd boards/Pynq-Z2/ && make`

all designs generated and tested with Vivado 2017.4.

## 2- Running the software on PYNQ

Make sure that you are connected to the board.

### Installing hardware design to the Board.

To test and use the prebuilt overlay design please run this command from the board.

`sudo pip3 install --upgrade git+https://github.com/RCL-lab/sha1_pynq.git`

This is tested on [PYNQ-Z1 v2.4 PYNQ image](http://bit.ly/2V9MB9v) and [PYNQ-Z2 v2.4 PYNQ image](http://bit.ly/2E3BxUF)

### Running the test program

Access to the jupyter notebook on the board by entering IP address of the board to the browser on your host machine.
Locate to the `sha1.ipynb` file under `sha1_pynq/` folder in Jupyter notebooks and run the program. You should see 'Test Passed' massage if everthing is working as expected.

##### Useful Links:

[Link that explains message padding](https://www.ipa.go.jp/security/rfc/RFC3174EN.html#4)

[Pynq-Getting Started Web Page](https://pynq.readthedocs.io/en/latest/getting_started.html)

[Pynq-Z1 Setup Guide](https://pynq.readthedocs.io/en/latest/getting_started/pynq_z1_setup.html)

[Setup Vivado](https://pynq.readthedocs.io/en/latest/overlay_design_methodology/board_settings.html)

[Overlay Tutorial](https://pynq.readthedocs.io/en/latest/overlay_design_methodology/overlay_tutorial.html)

