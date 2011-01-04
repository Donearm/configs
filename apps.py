from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
    def app_fehgallery(self, c):
        return tup('/usr/local/bin/fehgallery.py', *c)

    def app_mplayer(self, c):
        if c.mode is 1:
            return tup('/usr/local/bin/mplayerss.sh', '-fs', *c)
        elif c.mode is 2:
            return tup('/usr/local/bin/mplayerss.sh', *c)
        else:
            return tup('/usr/local/bin/mplayerss.sh', *c)

    def app_unrar(self, c):
        c.flags += 'd'
        return tup('unrar', 'x -kb -y', c.file.path)

    def app_unzip(self, c):
        c.flags += 'd'
        return tup('unzip', c.file.path)

    def app_tar(self, c):
        c.flags += 'd'
        return tup('tar', 'xvf', c.file.path)

    def app_soffice(self, c):
        c.flags += 'd'
        return tup('soffice', *c)


    def app_default(self, c):
        f = c.file # shortcut

        if f.extension is not None:
            if f.extension in ('pdf', ):
                c.flags += 'd'
                return self.either(c, 'evince', 'zathura')
            if f.extension in ('xml', ):
                return self.either(c, 'editor')
            if f.extension in ('html', 'htm', 'xhtml'):
                return self.either(c, 'firefox', 'links-g')
            if f.extension in ('swf', ):
                return self.either(c, 'firefox', 'links-g')
            if f.extension in ('gif', ):
                return self.either(c, 'firefox -new-tab', 'feh')
            if f.extension in ('rar', ):
                return self.app_unrar(c)
            if f.extension in ('zip', ):
                return self.app_unzip(c)
            if f.extension in ('bz2', 'gz', 'tar', 'tgz', 'tbz2', 'tbz', 'bz'):
                return self.app_tar(c)
            if f.extension in ('odw', 'ods', 'odt', 'xls', 'doc', 'odg'):
                return self.app_soffice(c)

        if f.video or f.audio:
            return self.app_mplayer(c)

        if f.image:
            return self.app_fehgallery(c)

        return DefaultApps.app_default(self, c)
