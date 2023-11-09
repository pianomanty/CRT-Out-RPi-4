#!/bin/bash

# **BEFORE RUNNING, MAKE SURE TO BOOT RETROPIE, SETUP INTERNET, 
# UPDATE SYSTEM PACKAGES, THEN GO TO Config -> Raspi-Config -> Advanced Options -> GL Driver
# SELECT GL (Fake KMS) OpenGL desktop driver with fake KMS **

#go into config -> audio -> mixer and change the volume to 100 as well

# clone the "retropie-crt-tvout repo to a temp folder
sudo mkdir /temp_files
sudo git clone https://github.com/Sakitoshi/retropie-crt-tvout.git /temp_files
sudo unzip /temp_files/arcade_tweaks.zip -d /temp_files

# Distribute the repo's files
sudo cp -r /temp_files/to_configs/* /opt/retropie/configs
sudo cp -r /temp_files/to_bios/* /home/pi/RetroPie/BIOS/palettes
sudo cp -r /temp_files/arcade/* /opt/retropie/configs/arcade

# Edit the yres arguments
# Remove -yres 448 from /opt/retropie/configs/all/runcommand-onstart.sh
sudo sed -i.bak 's/-yres 448//' /opt/retropie/configs/all/runcommand-onstart.sh
# -yres 480 from configs/all/runcommand-onend.sh
sudo sed -i.bak 's/-yres 480//' /opt/retropie/configs/all/runcommand-onend.sh

# make new config.txt and overwrite the old one
sudo touch /temp_files/config.txt
sudo echo "# Enable audio (loads snd_bcm2835)" >> /temp_files/config.txt
sudo echo "dtparam=audio=on" >> /temp_files/config.txt
sudo echo "[pi4]" >> /temp_files/config.txt
sudo echo "# Enable DRM VC4 V3D driver on top of the dispmanx display stack" >> /temp_files/config.txt
sudo echo "dtoverlay=vc4-fkms-v3d" >> /temp_files/config.txt
sudo echo "max_framebuffers=2" >> /temp_files/config.txt
sudo echo "# Optional Overclock" >> /temp_files/config.txt
sudo echo "# over_voltage=6" >> /temp_files/config.txt
sudo echo "# arm_freq=2000" >> /temp_files/config.txt
sudo echo "# gpu_freq=700" >> /temp_files/config.txt
sudo echo "# TV Output" >> /temp_files/config.txt
sudo echo "framebuffer_width=720" >> /temp_files/config.txt
sudo echo "framebuffer_height=448" >> /temp_files/config.txt
sudo echo "enable_tvout=1" >> /temp_files/config.txt
sudo echo "sdtv_mode=16" >> /temp_files/config.txt
sudo echo "sdtv_aspect=1" >> /temp_files/config.txt
sudo echo "disable_overscan=1" >> /temp_files/config.txt
sudo echo "# Audio" >> /temp_files/config.txt
sudo echo "audio_pwm_mode=2" >> /temp_files/config.txt
sudo echo "[all]" >> /temp_files/config.txt
sudo echo "dtoverlay=vc4-fkms-v3d" >> /temp_files/config.txt
sudo echo "overscan_scale=1" >> /temp_files/config.txt
sudo cp /temp_files/config.txt /boot/config.txt

# edit /opt/retropie/configs/all/autostart.sh to boot in 240p then switch to 480i
sudo touch /temp_files/autostart.txt
sudo echo "if tvservice -s | grep NTSC; then" >> /temp_files/autostart.txt
sudo echo '    tvservice -c "NTSC 4:3"' >> /temp_files/autostart.txt
sudo echo "    emulationstation --screensize 640 448 --screenoffset 38 16 \#auto" >> /temp_files/autostart.txt
sudo echo "else" >> /temp_files/autostart.txt
sudo echo "    emulationstation \#auto" >> /temp_files/autostart.txt
sudo echo "fi" >> /temp_files/autostart.txt
sudo mv /temp_files/autostart.txt /temp_files/autostart.sh
sudo cp /temp_files/autostart.sh /opt/retropie/configs/all/autostart.sh

# Edit /opt/retropie/configs/all/runcommand-onstart.sh
sudo head -n -1 /opt/retropie/configs/all/runcommand-onstart.sh > /temp_files/temp.txt
sudo echo 'if tvservice -s | grep NTSC && { ! echo "$3" | grep -wi "$interlaced" || echo "$interlaced" | grep empty; } && ! echo "$interlaced" | grep -xi "all" && { echo "$3" | grep -wi "$progresive" || echo "$progresive" | grep empty; }; then' >> /temp_files/temp.txt
sudo echo '    echo tvservice -c "NTSC 4:3 P"; fbset -depth 8; fbset -depth 32' >> /temp_files/temp.txt
sudo echo 'else' >> /temp_files/temp.txt
sudo echo '    { sleep 10 && tvservice -c "NTSC 4:3"; fbset -depth 8; fbset -depth 32; } &' >> /temp_files/temp.txt
sudo echo 'fi > /dev/null' >> /temp_files/temp.txt
sudo mv /temp_files/temp.txt /opt/retropie/configs/all/runcommand-onstart.sh

# Delete the temporary downloaded files
rm -r /temp_files

