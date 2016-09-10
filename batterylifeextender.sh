#!/bin/sh

########################################################################
# BatteryLifeExtender <https://github.com/pirafrank/battery_life_extender>
# Notifies the user when plug or unplug the power cord to extend
# the overall battery life
#
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

status="$(pmset -g batt | egrep "([0-9]+\%).*" -o)"
substring1="discharging"
charge="$(cut -d '%' -f 1 <<< "$status")"
title="BatteryLifeExtender"
message=""
action=""

if [ "${status/$substring1}" = "$status" ] ; then
  if [ "$charge" -ge 80 ] ; then
    message="You can now unplug the power cord to extend the overall battery life."
    action="Unplug"
  else
    exit 0
  fi
else
  if [ "$charge" -le 40 ] ; then
    message="You should plug your Mac to a power outlet to extend the overall battery life."
    action="Plug"
  else
    exit 0
  fi
fi

# Hide ALL output including background job info
if [ -t 1 ] ; then exec 1>/dev/null ; fi
if [ -t 2 ] ; then exec 2>/dev/null ; fi

script="display notification \"${message}\" with title \"${title}\" subtitle \"${action} your Mac! Charge is ${charge}%\" sound name \"Sosumi\""

if [ -n "$TMUX" ] && type -f -t reattach-to-user-namespace >/dev/null ; then
  `type -f -p reattach-to-user-namespace` /usr/bin/osascript -e "${script}" -e "delay 1" &
else
  /usr/bin/osascript -e "${script}" -e "delay 1" &
fi
