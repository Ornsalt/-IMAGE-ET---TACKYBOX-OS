#########################################
## PROJECT      : Tack-Os - Image Et   ##
## DATE         : 2023                 ##
## ENVIRONEMENT : Unix                 ##
## DEPENDENCIES : Docker               ##
## AUTHOR       : MONFORT Clément      ##
##                AUGER   Clément      ##
#########################################

######################
## PARSING VARIABLE ##
######################

## Name of the umbrella and Path of the service(s) folder.
TRG		= tackybox
DIR		= ./app/

## Name of the file(s) to parse for initialisation of each services.
INI		= $(TRG).toml

##########################
## COMPILATION VARIABLE ##
##########################

## list of  none derivable applications like the (db, ... ).
LIST	= DBMS

## Sources folder of the target(s) service(s).
SRC		= $(filter-out GLOBAL, $(shell grep -o '\[.*\]' ${INI} | sed 's/"//g' | sed 's/\[//g' | sed 's/\]//g'))

## Rule name to delete each container and image.
CLN		= $(addprefix clean_, $(SRC))

## [DEBUGS] Networks variables.
CARD		= $(shell ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
IP		= $(shell hostname -I | cut -d ' ' -f1)

########################
## ARGUMENTS VARIABLE ##
########################

## DBMS initialisations values.
SOURCE	= ~/Documents/examens/
TARGET	= /appli/examens/
NAME	= db
PORT	= 3306
USER	= imageet
ROOT	= root_root
PWD	= tkb_image_et
IMG	= mysql:5.7

#######################
## MAKEFILE VARIABLE ##
#######################
MAKEFLAGS += --no-print-directory

####################
## MAKEFILE RULES ##
####################
.DEFAULT_TARGET: help
.PHONY: env clean purge help $(SRC) $(CLN)

env:
## Globale and debug values.
	@echo "[GLOBAL]\nsCard=\"$(CARD)\"\nsIP=\"$(IP)\"\n" > $(INI)
	
## None derivable applications.
	@echo "[DBMS]\nsSource=\"$(SOURCE)\"\nsTarget=\"$(TARGET)\"\nsImage=\"$(IMG)\"\niPort=$(PORT)\nsName=\"$(NAME)\"\nsUser=\"$(USER)\"\nsRoot=\"$(ROOT)\"\nsPWD=\"$(PWD)\"\n" >> $(INI)
	
## Derivable applications.
	@for src in $(filter-out $(LIST), $(shell find $(DIR) -mindepth 1 -maxdepth 1 -not -empty -type d -printf '%f\n' | sort -k 2)); do echo "[$$src]\nsImage=\"imageetdev/tackybox-ae$$src:transfer-only\"\nsDest=\"AET@IP:PORT\"\nsAET=\"$$src\"\n" >> $(INI); done

help:
	@clear

	@echo "📦 \033[1mDependencies :\033[0m"
	@echo "\t\e]8;;https://docs.docker.com/desktop/install/linux-install/\aDocker engine\e]8;;\a\n"
	@echo "\tnet-tools\n"

	@echo "🔮 \033[1mmake env :\033[0m"
	@echo "\tCreate the Makefile's initialisation file : \033[1m$(INI)\033[0m.\n"
	@echo "\t❗ To add your own application:"
	@echo "\tYou must have a folder named after the application in \033[1m$(DIR)\033[0m."
	@echo "\tWitch has the source code (app/src/) or docker-compose.yml and a Makefile within.\n"

	@echo "🔮 \033[1mmake help :\033[0m"
	@echo "\tDisplay the $(TRG) documentation (you are here).\n"

	@echo "🔮 \033[1mmake clean :\033[0m"
	@echo "\tRemove all Docker's images containers and volumes of the applications handled by the Makefile.\n"

	@echo "🔮 \033[1mmake purge :\033[0m"
	@echo "\tRemove all Docker's images and containers of the application handled by the Makefile.\n"
	@echo "\tRemove all Docker's images, containers and networks unused.\n"

	@echo "🔮 \033[1mmake <application> :\033[0m"
	@echo "\tBuild and launch the Docker's container of the application.\n"

clean: $(CLN)
	
purge: clean
	@echo "Killer Clean third detergent.\nWipe za Dusto !"
	@echo "y\n" | docker system prune --all --volumes > /dev/null

$(CLN):
	make -C $(DIR)$(subst clean_,,$@)/ clean

$(SRC):
	@echo "🔮 \033[1m$@ on $(CARD):$(IP)\033[0m"
	@make -C $(DIR)$@/ compose INI=../../$(INI)
