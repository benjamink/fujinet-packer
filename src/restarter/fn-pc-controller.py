import PySimpleGUI as sg
import psutil

ATARI_PROCESS = "top"
APPLE_PROCESS = "fn-pc-apple"
ATARI_RUNNING = [ATARI_PROCESS in (p.name() for p in psutil.process_iter())]
APPLE_RUNNING = True

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
    [sg.HSeparator()],
    [sg.StatusBar(f'Atari: {ATARI_STATUS} Apple: {
                  APPLE_STATUS}', justification='center', key='STATUS')],
]

window = sg.Window('FujiNet PC Process Controller', layout)

while True:
  event, values = window.read()
  window['STATUS'].update(f'Atari: {ATARI_STATUS} Apple: {APPLE_STATUS}')
  if event == sg.WIN_CLOSED or event == 'Exit':
    break

  if event == 'ATARI_LOGS':
    window['LOGS_OUTPUT'].update(value='Atari logs')
    if ATARI_STATUS == 'Running':
        ATARI_STATUS = 'Stopped'
    else:
        ATARI_STATUS = 'Running'
  elif event == 'APPLE_LOGS':
    window['LOGS_OUTPUT'].update(value='Apple logs')
    if APPLE_STATUS == 'Running':
        APPLE_STATUS = 'Stopped'
    else:
        APPLE_STATUS = 'Running'


window.close()
