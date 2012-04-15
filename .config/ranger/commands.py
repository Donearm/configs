# Copyright (C) 2009, 2010  Roman Zimbelmann <romanz@lavabit.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

'''
This is the default file for command definitions.

Each command is a subclass of `Command'.  Several methods are defined
to interface with the console:
	execute: call this method when the command is executed.
	tab: call this method when tab is pressed.
	quick: call this method after each keypress.

The return values for tab() can be either:
	None: There is no tab completion
	A string: Change the console to this string
	A list/tuple/generator: cycle through every item in it
The return value for quick() can be:
	False: Nothing happens
	True: Execute the command afterwards
The return value for execute() doesn't matter.

If you want to add custom commands, you can create a file
~/.config/ranger/commands.py, add the line:
	from ranger.api.commands import *

and write some command definitions, for example:

	class tabnew(Command):
		def execute(self):
			self.fm.tab_new()

	class tabgo(Command):
		"""
		:tabgo <n>

		Go to the nth tab.
		"""
		def execute(self):
			num = self.line.split()[1]
			self.fm.tab_open(int(num))

For a list of all actions, check /ranger/core/actions.py.
'''

from ranger.api.commands import *

class urxvt(Command):
    """
    :urxvt

    Spawns urxvtc (needs urxvtd running).
    """
    def execute(self):
        self.fm.run('urxvtc', flags='d')
