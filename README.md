# AMD RX 480/570/580 Mining on Ubuntu Server 16.04.3 LTS

### Install Ubuntu HWE stack
https://help.ubuntu.com/community/AMDGPU-Driver
https://wiki.ubuntu.com/Kernel/LTSEnablementStack

```sh
sudo apt-get update
sudo apt-get install --install-recommends linux-generic-hwe-16.04
sudo apt-get upgrade
```

### Locale fix
```sh
sudo locale-gen en_US en_US.UTF-8 hu_HU hu_HU.UTF-8
sudo dpkg-reconfigure locales
```

### mdadm.conf defines no arrays fix
```sh
sudo vi /etc/mdadm/mdadm.conf
```

Add this line below ```#definitions of existing MD arrays```
```sh
ARRAY <ignore> devices=/dev/sda
```

### Disable screensaver, AMD tweaks, fall back to ethX network interface naming
Edit the grub configuration file:
```sh
sudo vi /etc/default/grub
```

Replace ```GRUB_CMDLINE_LINUX_DEFAULT``` and ```GRUB_CMDLINE_LINUX``` lines
```sh
GRUB_CMDLINE_LINUX_DEFAULT="text amdgpu.dc=1 amdgpu.powerplay=1"
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
```

Edit network configuration file:
```sh
sudo vi /etc/network/interfaces
```

Replace ```enpXsX``` to ```eth0```
```sh
# The primary network interface
auto eth0
iface eth0 inet dhcp
```

Update grub configuration
```sh
sudo update-grub
sudo reboot
```

### Install AMDGPU Driver + OpenCL + ROCm
http://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx
```sh
wget https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.50-511655.tar.xz --referer http://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx
tar -Jxvf amdgpu-pro-17.50-511655.tar.xz
cd amdgpu-pro-17.50-511655
./amdgpu-pro-install --opencl=legacy,rocm --headless
sudo apt install opencl-amdgpu-pro
```

Add yourself to the video group
```sh
sudo usermod -a -G video $LOGNAME
```

### Check your graphic card name and chipset
```sh
sudo update-pciids
lspci -nn | grep -E 'VGA|Display'
```

### AMDGPU commands (clinfo ...)
Edit your ```.profile```
```sh
vi ~/.profile
```
and amdgpu-pro PATH
```sh
PATH="/opt/amdgpu-pro/bin:$PATH"
```

## Tuning

### Save Bios
```sh
sudo ./atiflash -s 0 CARD-NAME.rom
```

### How To Mod Bios 470/570/480/580/VEGA on windows
https://bitcointalk.org/index.php?topic=1954245.0

Download Polaris Bios Editor
```
https://github.com/jaschaknack/PolarisBiosEditor
```
One Click Timing Patch

### Flash Bios Mod
```sh
sudo ./atiflash -p 0 CARD-NAME.rom
```

### Overclocking and undervolting support

https://github.com/OhGodACompany/OhGodATool is a tool that allows both of this. It has been tested with Polaris on 4.13 kernels and does allow undervolting/overclocking via the power-play tables.

#### Undervolting example

1. Display the voltage and core clock table :

```sh
sudo ./ohgodatool -i 0 --show-core --show-voltage
```
```
DPM state 0:
	VDDC: 750 (voltage table entry 0)
	VDDC offset: 0
	Core clock: 300
DPM state 1:
	VDDC: 65282 (voltage table entry 1)
	VDDC offset: -26
	Core clock: 600
DPM state 2:
	VDDC: 65283 (voltage table entry 2)
	VDDC offset: -26
	Core clock: 900
DPM state 3:
	VDDC: 65283 (voltage table entry 2)
	VDDC offset: -26
	Core clock: 1145
DPM state 4:
	VDDC: 65285 (voltage table entry 4)
	VDDC offset: -26
	Core clock: 1215
DPM state 5:
	VDDC: 65286 (voltage table entry 5)
	VDDC offset: -26
	Core clock: 1257
DPM state 6:
	VDDC: 65287 (voltage table entry 6)
	VDDC offset: -26
	Core clock: 1300
DPM state 7:
	VDDC: 65288 (voltage table entry 7)
	VDDC offset: 0
	Core clock: 1145

Voltage state 0:
	VDD = 750
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 1:
	VDD = 65282
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 2:
	VDD = 65283
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 3:
	VDD = 65284
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 4:
	VDD = 65285
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 5:
	VDD = 65286
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 6:
	VDD = 65287
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 7:
	VDD = 65288
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 8:
	VDD = 800
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 9:
	VDD = 850
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 10:
	VDD = 900
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 11:
	VDD = 950
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 12:
	VDD = 1000
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 13:
	VDD = 1050
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 14:
	VDD = 1100
	CACLow = 0
	CACMid = 0
	CACHigh = 0
Voltage state 15:
	VDD = 1150
	CACLow = 0
	CACMid = 0
	CACHigh = 0
```

2. Assign the choosen voltage

```sh
sudo ./ohgodatool -i 0 --core-state 7 --core-vddc-idx 3
```
```
Core state 7 VDDC: 7 -> 11
```

#### Overclocking example

1. List the current memory clock

```sh
sudo ./ohgodatool -i 0 --show-mem
```
```
Memory state 0:
	VDDC: 750
	VDDCI: 850
	VDDC GFX offset: 0
	MVDD: 1000
	Memory clock: 300
Memory state 1:
	VDDC: 65282
	VDDCI: 850
	VDDC GFX offset: 0
	MVDD: 1000
	Memory clock: 1000
Memory state 2:
	VDDC: 65283
	VDDCI: 900
	VDDC GFX offset: 0
	MVDD: 1000
	Memory clock: 1750
```

2. Change the last clock in the table

```sh
sudo ./ohgodatool -i 0 --mem-state 2  --mem-clock 2150
```
```
Memory state 2 clock: 1750 -> 2150.
```

## Install miners
### xmr-stak (XMR/ETN mining)
```sh
sudo apt install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev
sudo apt-get install opencl-headers
git clone https://github.com/fireice-uk/xmr-stak.git
mkdir xmr-stak/build
cd xmr-stak/build
cmake .. -DCUDA_ENABLE=OFF -DOpenCL_INCLUDE_DIR=/usr/include/CL
cmake --build .
```

Create config files / start mining
```sh
./xmr-stak
```

Stop mining (ctrl+c)
Edit ```amd.txt``` and duplicate threads
```json
"gpu_threads_conf" : [
  { "index" : 0, "intensity" : 896, "worksize" : 8, "affine_to_cpu" : false, "strided_index" : true },
  { "index" : 0, "intensity" : 896, "worksize" : 8, "affine_to_cpu" : false, "strided_index" : true },
],
```

### Ethminer (ETH mining)
```sh
https://github.com/ethereum-mining/ethminer.git
cd ethminer
mkdir build; cd build
cmake ..
cmake --build .
cd ethminer
```

Start mining
```sh
./ethminer -G --cl-kernel 1 --cl-local-work 256 --cl-global-work 65536 --cl-parallel-hash 2 -RH -HWMON -SC 2 -SP 0 -S eu2.ethermine.org:4444 -FS eu1.ethermine.org:4444 -O 0xc3f2ac3149b3466A68DC81163A27E6ba11e79560.rig1
```
