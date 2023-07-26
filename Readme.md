# Tackybox-Python

This project is a new version of the [Tackybox](https://github.com/IMAGE-ET/tacky-box-mere).

Tackybox is a system to send DICOM images in the network.
The previous iteration has 3 weaknesses. Lack of transparency, fiability, and is difficult to deploy.

DICOM stand for Digital Imaging and Communication in Medicine.
More information about this widely used standard are on the official site : https://www.dicomstandard.org.


This project uses the pynetdicom package to allow python scripts to run and exchange with other DICOM complying devices.

This repo contain 2 folders, to construct tackyboxes mothers and daughters.
Each got subfolders for each container parts.

The senders (daughters) receive data using a DICOM receiver, then send it to one or more mother tackybox using the rsync syscall (for data transmission) and fork. It update a database mysql for maintenance purpose.

The receivers (mothers), receive data from the daugthers, then forward it to a destination in DICOM (C-STORE request). It uses C-ECHO to be sure the destination is online. It also has a mysql database for transparency purposes.

### Docker

To build images, you must go in the subfolder of each part and run a classic ```docker build```(using -t for tagging is recommended)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Docker CLI is the only prerequisite, but a Graphical interface like Docker Desktop could be enjoyable

### Installing

Pull the repo, and recreate the hardlinks between the mysql_utilities at root and each subpart, using the hardlink_builder script


### Running the tests

This project hasn't yet any automatised tests.

### Deployment

To deploy the tackybox on a live system, and start transmitting images, follow those steps.

* Pull the Compose on 2 or more computers. One daughter per local network (sites) where examens are done, and one mother per local network of the targeted archives.
* Connect each mother with the archive. Add the AETArchive of the archive to the receiver. You can find/edit it in the compose file. Add the AET of the box to the archive (to let it allow C-STORE request)
* Connect the modalities of each site with the tackybox daughter (register the Daughter AET in each modality), so each can C-STORE in the Tackybox.
* Register the address of each destination for each daughter in the compose file.

The link is built, images can transit.

Following is setting up the mysql database for monitoring purposes.
This part work independently of mother or daughter.
Once the env are changed from the template of each compose files, you need to run the migration on the container. This can be done by running tackybox.sql against the database. The line to do so is :
```
docker exec -i daugther-db-1 mysql -u user -ppassword < ../tackybox.sql
```

- daughter-db-1 is the name of the container (docker ps to get it)
- user is the MYSQL_USER from the env in docker compose
- password is the MYSQL_PASSWORD from the env in docker compose

## Author

* [AUGER Clément](https://github.com/AUGERClement) for the company [Image-ET](www.image-et.fr)

## Acknowledgments

* The well built documentation of PynetDICOM
