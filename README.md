# TACKY-OS

This repository contain the source code to set-up your very own tacky-box.

Every comandes shown are supposed to be used at the root of the project.

Use the following commandes for more detailes on cleaning.

```shell
make help
```


## SETUP

* This script will update your distro, install and configure git and **reboot** your machine.
* Yes it will really **REBOOT** so your session receive the changes.
* Only use sudo on the setup script !
* The seconde commande will create the configuration file, it's a necessary step.

```shell
sudo ./setup.sh

make env
```

## DBSM

* You need it for any type boxes.

```shell
make env && make DBSM
```

## MOTHER

* You need to rename the aet and destination on the .toml.

```shell
make env && make server
```

## DAUTHER

* You need to rename the aet and destination on the .toml.

```shell
make env && make client
```
