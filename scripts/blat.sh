#!/bin/bash
set -x

rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p generic/ ~/
rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p ${2}/ ~/
rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p locals/${1}/ ~/

DATE=`git show -s --format=%ci -q HEAD`
COMMIT=`git rev-parse --short HEAD`
BRANCH=`git rev-parse --abbrev-ref HEAD`

echo "dotfiles from '${BRANCH}' branch at ${COMMIT}; date: ${DATE}." > ~/.dotfiles.version
