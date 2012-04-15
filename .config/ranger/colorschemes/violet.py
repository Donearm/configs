from ranger.gui.color import *
from ranger.colorschemes.default import Default
import curses

class Scheme(Default):
    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if curses.COLORS < 88:
            return fg, bg, attr

        dircolor = 55
        dircolor_selected = { True: 79, False: 78 }
        linkcolor = { True: 84, False: 48 }

        if context.in_browser:
            if context.media:
                if context.image:
                    fg = 48
                elif context.video:
                    fg = 61
                elif context.audio:
                    fg = 42 

            if context.container:
                fg = 52

            if context.directory:
                fg = dircolor
            elif context.executable and not \
                    any((context.media, context.container)):
                fg = 40
            
            if context.link and not context.directory:
                fg = linkcolor[context.good]

            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 56

            if context.in_titlebar:
                if context.hostname:
                    fg = context.bad and 61 or 54
                elif context.directory:
                    fg = dircolor
                elif context.link:
                    fg = linkcolor[True]

        return fg, bg, attr
