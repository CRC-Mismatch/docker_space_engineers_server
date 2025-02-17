#!/bin/bash

set -x

if [ ! -d ${WORK} ]; then
	# Setup folder for steamcmd data
	mkdir -p ${WORK}
fi

if [ ! -d ${CONFIG} ]; then
	# Setup folder for space engineers data
	mkdir -p ${CONFIG}
fi

if [ ! -d ${CONFIG}/Saves ]; then
	# Setup folder for saves
	mkdir -p ${CONFIG}/Saves
fi

if [ ! -d ${CONFIG}/Mods ]; then
	# Setup folder for mods
	mkdir -p ${CONFIG}/Mods
fi

if [ ! -d ${CONFIG}/Updater ]; then
	# Setup folder for updater
	mkdir -p ${CONFIG}/Updater
fi

if [ -d ${WORK}/${WORLD_NAME} ]; then
	# Copy save to save location
	cp -r ${WORK}/${WORLD_NAME} ${CONFIG}/Saves/
	chown -R root:root ${CONFIG}/Saves/${WORLD_NAME}
fi

if [ ! -f ${WORK}/Torch.cfg ]; then
	# Copy standard config file to correct location
	cp /home/root/Torch.cfg ${WORK}
fi

# Change ports
sed -i 's=<SteamPort>.*</SteamPort>=<SteamPort>'${STEAM_PORT}'</SteamPort>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg
sed -i 's=<ServerPort>.*</ServerPort>=<ServerPort>'${SERVER_PORT}'</ServerPort>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg

# Change save path to value from config
sed -i 's=<ServerName>.*</ServerName>=<ServerName>'${SERVER_NAME}'</ServerName>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg
sed -i 's=<GroupID>.*</GroupID>=<GroupID>'${GROUP_ID}'</GroupID>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg
sed -i 's=<WorldName>.*</WorldName>=<WorldName>'${WORLD_NAME}'</WorldName>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg
sed -i 's=<LoadWorld>.*</LoadWorld>=<LoadWorld>Z:\\mnt\\root\\space-engineers-server\\config\\Saves\\'${WORLD_NAME}'</LoadWorld>=g' ${CONFIG}/SpaceEngineers-Dedicated.cfg

# Change Torch settings
sed -i 's=<InstanceName>.*</InstanceName>=<InstanceName>'${WORLD_NAME}'</InstanceName>=g' ${WORK}/Torch.cfg

/home/root/steamcmd/steamcmd.sh +login anonymous +force_install_dir ${WORK} +app_update 298740 +quit
cd ${WORK}
wine Torch.Server.exe -instancepath Z:\\mnt\\root\\space-engineers-server\\config -instancename ${WORLD_NAME} -nogui -autostart
