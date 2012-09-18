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
                fg = yellow
            if context.container:
                fg = red
            if context.directory:
                attr |= bold
                fg = 52
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
                fg = yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and cyan or magenta
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 52
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

        elif context.in_titlebar:
            if context.hostname:
                fg = context.bad and 52 or 58
            elif context.directory:
                fg = 52
            elif context.tab:
                if context.good:
                    attr |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = yellow
                elif context.bad:
                    fg = red
            if context.marked:
                attr |= bold | reverse
                fg = yellow
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
