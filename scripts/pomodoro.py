# Migrated to the-thing project..

import signal
import sys
from PyQt5 import QtWidgets, QtCore, QtGui


REST_DURATION = 5
TOO_EARLY = 800
TOO_LATE = 1900
TIMER = QtCore.QTimer()
WORK_DURATION = 20


class PomodoroTimer(QtWidgets.QSystemTrayIcon):

    def __init__(self, icon, parent=None):
        QtWidgets.QSystemTrayIcon.__init__(self, icon, parent)
        menu = QtWidgets.QMenu(parent)
        menu.addAction("Exit")
        self.setContextMenu(menu)
        menu.triggered.connect(self.exit)

    def exit(self):
        QtCore.QCoreApplication.exit()


def tray_icon(image):
    app = QtWidgets.QApplication(sys.argv)
    w = QtWidgets.QWidget()
    trayIcon = PomodoroTimer(QtGui.QIcon(image), w)
    trayIcon.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    work_icon = '/home/lpowers/dropbox/graphics/kid.png'
    rest_icon = '/home/lpowers/dropbox/graphics/I-guess.jpg'
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    tray_icon(rest_icon)
