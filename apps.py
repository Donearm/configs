from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
    def app_fehgallery(self, c):
        return tup('/usr/local/bin/fehgallery.lua', *c)

    def app_display(self, c):
        return tup('display', *c)

    def app_mplayer(self, c):
        c.flags += 'd'
        if c.mode is 1:
            return tup('nohup', 'setsid', '/usr/local/bin/mplayerss.sh', '-fs', *c)
        elif c.mode is 2:
            return tup('nohup', 'setsid', '/usr/local/bin/mplayerss.sh', *c)
        else:
            return tup('nohup', 'setsid', '/usr/local/bin/mplayerss.sh', *c)

    def app_gnomemplayer(self, c):
        c.flags += 'd'
        return tup('gnome-mplayer', '--playlist', c.file.path)

    def app_unrar(self, c):
        c.flags += 'd'
        return tup('unrar', 'x -kb -y', c.file.path)

    def app_unzip(self, c):
        c.flags += 'd'
        return tup('unzip', c.file.path)

    def app_7z(self, c):
        c.flags += 'd'
        return tup('7z', 'x', c.file.path)

    def app_tar(self, c):
        c.flags += 'd'
        return tup('tar', 'xvf', c.file.path)

    def app_bunzip2(self, c):
        c.flags += 'd'
        return tup('bunzip2', c.file.path)

    def app_gunzip(self, c):
        c.flags += 'd'
        return tup('gunzip', c.file.path)
    
    def app_soffice(self, c):
        c.flags += 'd'
        return tup('soffice', *c)

    def app_fbreader(self, c):
        c.flags += 'd'
        return tup('FBReader', *c)


    def app_default(self, c):
        f = c.file # shortcut

        if f.extension is not None:
            if f.extension in ('pdf', ):
                c.flags += 'd'
                return self.either(c, 'evince', 'epdfview', 'zathura')
            if f.extension in ('xml', ):
                return self.either(c, 'editor')
            if f.extension in ('html', 'htm', 'xhtml'):
                return self.either(c, 'firefox', 'links-g')
            if f.extension in ('swf', ):
                return self.either(c, 'firefox', 'links-g')
            if f.extension in ('gif', ):
                return self.either(c, 'firefox', 'feh')
            if f.extension in ('rar', ):
                return self.app_unrar(c)
            if f.extension in ('zip', ):
                return self.app_unzip(c)
            if f.extension in ('7z', ):
                return self.app_7z(c)
            if f.extension in ('f4v', 'm4v' ):
                return self.app_mplayer(c)
            if f.extension in ('tar.bz2', 'tar.gz', 'tar', 'tgz', 'tbz2', 'tbz', 'bz'):
                return self.app_tar(c)
            if f.extension in ('bz2'):
                return self.app_bunzip2(c)
            if f.extension in ('gz'):
                return self.app_gunzip(c)
            if f.extension in ('odw', 'ods', 'odt', 'xls', 'doc', 'odg', 'rtf'):
                return self.app_soffice(c)
            if f.extension in ('ts', ):
                return self.app_mplayer(c)
            if f.extension in ('svg', ):
                return self.app_display(c)
            if f.extension in ('pls', ):
                return self.app_gnomemplayer(c)
            if f.extension in ('mobi', 'epub'):
                return self.app_fbreader(c)

        if f.video or f.audio:
            return self.app_mplayer(c)

        if f.image:
            return self.app_fehgallery(c)

        return DefaultApps.app_default(self, c)
