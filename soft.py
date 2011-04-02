from ranger.gui.color import *
from ranger.colorschemes.default import Default
import curses

class Scheme(Default):
    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if curses.COLORS < 88:
            return fg, bg, attr

        dircolor = 137
        dircolor_selected = { True: 79, False: 78 }
        linkcolor = { True: 190, False: 48 }

        if context.in_browser:
            if context.media:
                if context.image:
                    fg = 203
                elif context.video:
                    fg = 149
                elif context.audio:
                    fg = 153

            if context.container:
                fg = 97

            if context.directory:
                fg = 137
            elif context.executable and not \
                    any((context.media, context.container)):
                fg = 231
            
            if context.link and not context.directory:
                fg = linkcolor[context.good]

            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 53

            if context.in_titlebar:
                if context.hostname:
                    fg = context.bad and 196 or 161
                elif context.directory:
                    fg = dircolor
                elif context.link:
                    fg = linkcolor[True]

        return fg, bg, attr
