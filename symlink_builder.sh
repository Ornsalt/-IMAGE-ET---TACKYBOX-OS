#!/bin/bash


# Due to some Docker limitation with contexts and parents folder,
# we need to put the file in each subpart for image construction.
# To avoid manual recreation of multiples hardlink, this script was created
ln ./mysql_utilities.py ./Daugther/AEServer/mysql_utilities.py
ln ./mysql_utilities.py ./Daugther/RsyncWrapper/mysql_utilities.py
ln ./mysql_utilities.py ./Mother/DBUpdater/mysql_utilities.py
ln ./mysql_utilities.py ./Mother/AEClient/mysql_utilities.py