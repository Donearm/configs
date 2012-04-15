from ranger.api.keys import *

map = KeyMapWithDirections()
keymanager.get_context('console')

# delete marked files right away
#map('D', fm.execute_console("shell -d rm -rf %s"))

keymanager.merge_all(map)
