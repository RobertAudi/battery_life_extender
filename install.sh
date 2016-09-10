#!/bin/bash

# Battery Life Extender install script

########################################################################
# BatteryLifeExtender <https://github.com/RobertAudi/battery_life_extender>
# Forked from <https://github.com/pirafrank/battery_life_extender>
# Notifies the user when plug or unplug the power cord to extend
# the overall battery life
#
# Copyright (C) 2016 Robert Audi
# Copyright (C) 2015 Francesco Pira <dev@fpira.com>
#
# This file is part of battery_life_extender
#
# battery_life_extender is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# battery_life_extender is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with battery_life_extender. If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

if [[ $EUID -ne 0 ]]; then
    echo "Sorry, no root priviledges."
    echo "Please rerun using 'sudo'!
    "
    exit 1
fi

repo_name="RobertAudi/battery_life_extender"

script_prefix="/usr/local/bin"
agent_prefix="/Library/LaunchAgents"

script_name="batterylifeextender.sh"
agent_name="me.audii.batterylifeextender.plist"

script_path="$(echo "${script_prefix}/${script_name}" | tr -s "/")"
agent_path="$(echo "${agent_prefix}/${agent_name}" | tr -s "/")"

script_url="https://raw.githubusercontent.com/${repo_name}/master/${script_name}"
agent_url="https://raw.githubusercontent.com/${repo_name}/master/${agent_name}"

script_temp_dir="/tmp/batterylifeextender"

echo "#####################
Welcome to battery life extender install script!
#####################"

mkdir -p "${script_temp_dir}"
cd "${script_temp_dir}"

echo "

Downloading executables..."
curl -o "${script_name}" "${script_url}"
curl -o "${agent_name}" "${agent_url}"

echo "
Installing..."

if [[ -f "${script_path}" ]]; then
  echo "Script already exists. Skipping."
else
  mkdir -p "${script_prefix}"
  cp "${script_name}" "${script_path}"
  chmod +x "${script_path}"
fi

if [[ -f "${agent_path}" ]]; then
  echo "Launch Agent already exists. Skipping."
else
  cp "${agent_name}" "${agent_path}"
  launchctl load "${agent_path}"
fi

echo "
Cleaning up..."
rm -rf "$script_temp_dir"
echo "
All done

"
