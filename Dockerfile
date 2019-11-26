FROM bregell/wine
MAINTAINER Johan Bregell

ENV WORK "/mnt/root/space-engineers-server"
ENV CONFIG "/mnt/root/space-engineers-server/config"
ENV SERVER_NAME DockerDedicated
ENV WORLD_NAME podTorchSpcEng
ENV STEAM_PORT 8766
ENV SERVER_PORT 27016
ENV GROUP_ID 0

USER root
RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		unzip
RUN mkdir -p ${WORK}
RUN mkdir -p ${CONFIG}
WORKDIR /home/root
COPY Torch.zip ${WORK}/Torch.zip
COPY Torch2.zip ${WORK}/Torch2.zip
COPY entrypoint.sh /entrypoint.sh
COPY Torch.cfg /home/root/Torch.cfg
RUN chmod +x /entrypoint.sh

WORKDIR ${WORK}
RUN wget -nc https://build.torchapi.net/job/Torch/job/Torch/job/master/lastSuccessfulBuild/artifact/bin/torch-server.zip \
        && unzip torch-server.zip \
        && unzip Torch.zip \
        && unzip Torch2.zip
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ${WORK}

EXPOSE ${STEAM_PORT}/udp
EXPOSE ${SERVER_PORT}/udp
