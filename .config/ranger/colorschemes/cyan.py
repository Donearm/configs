from ranger.gui.color import *
from ranger.colorschemes.default import Default

class Scheme(Default):
    def use(self, context):
        fg, bg, attr = default_colors

        linkcolor = { True: cyan, False: blue }

        if context.reset:
            return default_colors
        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = red
            if context.border:
                fg = default
            if context.media:
                fg = cyan
            if context.container:
                fg = blue
            if context.directory:
                attr |= bold
                fg = 60
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                fg = 25

            if context.link and not context.directory:
                fg = linkcolor[context.good]

            if context.socket:
                fg = magenta
                attr |= bold
            if context.fifo or context.device:
                fg = 59
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and cyan or 69
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (27, 63):
                    fg = white
                else:
                    fg = 27
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 69
            if context.badinfo:
                if attr & reverse:
                    bg = blue
                else:
                    fg = blue

        elif context.in_titlebar:
            if context.hostname:
                fg = context.bad and 69 or 63
            elif context.directory:
                fg = 60
            elif context.tab:
                if context.good:
                    attr |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 59
                elif context.bad:
                    fg = red
            if context.marked:
                attr |= bold | reverse
                fg = 59
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red

        if context.text:
            if context.highlight:
                attr |= reverse

            if context.selected:
                attr |= reverse

        return fg, bg, attr
