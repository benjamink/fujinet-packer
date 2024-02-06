import PySimpleGUI as sg
import dbus

sysbus = dbus.SystemBus()
systemd1 = sysbus.get_object(
    'org.freedesktop.systemd1', '/org/freedesktop/systemd1')
manager = dbus.Interface(systemd1, 'org.freedesktop.systemd1.Manager')

sg.theme('Dark Blue 3')

buttons = [
    [sg.Text('FujiNet PC for Atari')],
    [
        sg.Button('Restart', key='ATARI_RESTART'),
        sg.Button('Start', key='ATARI_START'),
        sg.Button('Stop', key='ATARI_STOP'),
        sg.Button('Logs', key='ATARI_LOGS')
    ],
    [sg.HSeparator()],
    [sg.Text('FujiNet PC for Apple')],
    [
        sg.Button('Restart', key='APPLE_RESTART'),
        sg.Button('Start', key='APPLE_START'),
        sg.Button('Stop', key='APPLE_STOP'),
        sg.Button('Logs', key='APPLE_LOGS')
    ],
]

layout = [
    buttons,
    # [sg.HSeparator()],
    # [sg.StatusBar(f'Atari: {ATARI_STATUS} Apple: {
    #              APPLE_STATUS}', justification='center', key='STATUS')],
]

window = sg.Window('FujiNet PC Process Controller', layout)


def restart(svc):
    try:
       manager.RestartUnit(svc)
    except:
       raise


while True:
  event, values = window.read()
  # window['STATUS'].update(f'Atari: {ATARI_STATUS} Apple: {APPLE_STATUS}')
  if event == sg.WIN_CLOSED:  # or event == 'Exit':
    break

  if event == 'ATARI_RESTART':
     restart('fn-pc-atari')
  elif event == 'APPLE_RESTART':
     restart('fn-pc-apple')


window.close()
