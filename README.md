# CRT-Out-RPi-4
Building on the work of Sakitoshi and prurigro, I wrote a bash script to easily configure a Raspberry Pi 4 for output to a CRT TV through the headphone jack.

On your raspberry pi 4, do a fresh install of the latest version of Retropie. Then, boot it, set up an internet connection,
then go to onfig -> Raspi-Config -> Advanced Options -> GL Driver
Select GL (Fake KMS) OpenGL desktop driver with fake KMS

Then, either clone the repository onto your /boot folder (or anywhere on the SD card), or just drag and drop it onto 
the SD card using another computer

Press f4 to access the terminal. Type the following command:
sudo bash /boot/RCA_out_config.sh

If all was successful, this will automatically configure everything else that's necessary.
Now, plug your 3.5mm to RCA cable into your Raspberry pi, then plug it into your CRT TV and enjoy beautiful analog video!

If you're wondering, I bought the "Adafruit A/V and RCA (Composite Video, Audio) Cable for Raspberry Pi"
