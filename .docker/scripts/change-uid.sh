#!/usr/bin/env bash

OLDUID=$(id -u nexus)
OLDGID=$(id -g nexus)

OLDDOCKERUID=$(id -u docker)
OLDDOCKERSGID=$(id -g docker)

NEWUID=$(id -u www-data)
NEWGID=$(id -g www-data)


sed -i "s/nexus:x:$OLDUID:$OLDGID/nexus:x:$NEWUID:$NEWGID/" /etc/passwd
sed -i "s/docker:x:$OLDDOCKERUID:$OLDDOCKERSGID/docker:x:$NEWUID:$NEWGID/" /etc/passwd