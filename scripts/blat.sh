#!/bin/bash
set -x

rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p generic/ ~/
rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p ${2}/ ~/
rsync ${3} --exclude '*.sw?' -HPvax --no-o --no-g --no-p locals/${1}/ ~/
