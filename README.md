# Secure ISO and PXE Desktop Creation

This simple script will create an unattended Ubuntu ISO from start to finish and enable a PXE Server which will enable building of a semi hardened build of 16.04 Ubuntu.


## Usage

* From your command line, run the following commands:

```
make vagrant
```

## What it does

This script does a bunch of stuff, here's the quick walk-through:

* Downloads the appropriate Ubuntu original ISO straight from the Ubuntu servers; if a file with the exact name exists, it will use that instead (so it won't download it more than once if you are creating several unattended ISO's with different defaults)
* Downloads the matching Ubuntu Netboot files to allow for PXE booting
* Sets up DNSMasq as a local DHCP Server and PXE/Tftp Server
* Sets up apt-proxy-ng as a local Apt Cache to save bandwidth when installing multiple machine.
* Language/locale: en_GB
* Keyboard layout: UK
* Root login disabled (so make sure you write down your default usernames' password!)
* Partitioning: LVM, full disk, with LUKS encryption following CIS partitioning layout guidelines
* Install the mkpasswd program (part of the whois package) to generate a hashed version of your password
* Install the genisoimage program to generate the new ISO file
* Mount the downloaded ISO image to a temporary folder
* Copy the contents of the original ISO to a working directory
* Set the default installer language
* Add/update the preseed file
* Add the autoinstall option to the installation menu
* Generate the new ISO file
* Cleanup
* Show a summary of what happended:

### Steps to install ...

To install a new desktop or laptop, connect a network cable from the machine to an isolated network. The seed server must also have on interface on the isolated network (it can be a point to point link) but must also have an internet connection to fetch remote packages. 
Once ready either set the machine to boot via PXE if this is an option or use a USB key with the image burnt as a preboot.
Notes:
- Upon first boot the system will ask for a few user details and a new LUKS password (choose something secure)
- this allows you to either add a single shared login root user or create a bespoke end user who has root permissions (@molliver still true?)
- The system will also run a couple of other hardening desktop settings as per the CESG desktop guidelines. 
- During the install you may be asked for a hostname but at this point you can use anything. 
- Once the install is complete the machine will reboot - at this point set the machine to not boot from the network or from USB in the BIOS and set a BIOS password.






### Steps to Create ISO ...

* Run the make as per above which will produce you an ISO image in the local directory.
* Burn the ISO to a USB key or CD as a bootable image.

To do this on OSx you can do:

```
diskutil list
diskutil unmountDisk /dev/disk4
diskutil list
# check that disk is the one you intend to overwrite
sudo dd if=${PWD}/xenial-custom-amd64.iso of=/dev/rdisk4 bs=1m
diskutil eject /dev/disk4
```

(where disk4 is the USB disk, if not change as appropriate)


## Design

This repo is designed as a base for the CESG Guidelines, these design decisions, mitigations and process are viewable here [development_desktops](development_desktops.md)
