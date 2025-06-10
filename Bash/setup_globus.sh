#!/bin/bash
sudo apt-get update
sudo apt-get install tk tcllib

cd ~/Ziwen
wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz
tar -xzf globusconnectpersonal-latest.tgz
mv globusconnectpersonal-* Globus
cd Globus
./globusconnectpersonal 
# Follow the instructions to set up Globus Connect Personal
echo "Globus Connect Personal setup is complete. Please follow the on-screen instructions to finish the configuration."
echo "You may need to restart your terminal or source your profile to use Globus Connect Personal."


