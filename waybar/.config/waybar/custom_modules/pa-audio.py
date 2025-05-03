#!/usr/bin/env python3

import json, os, re, subprocess, sys

def sh(cmd, stdin=None):
    return subprocess.check_output(cmd, input=stdin, text=True).strip()

def default_node(kind):
    for l in sh(['pactl', 'info']).splitlines():
        if l.startswith(f'Default {kind}'):
            return l.split(':', 1)[1].strip()

def nice_name(pulse_name):
    desc = ''
    block = sh(['pactl', 'list', 'sinks' if 'sink' in pulse_name else 'sources'])
    cur = False
    for l in block.splitlines():
        if l.startswith('Sink') or l.startswith('Source'):
            cur = pulse_name in l
        if cur and 'Description:' in l:
            desc = l.split(':', 1)[1].strip()
            break
    return desc or pulse_name

def volume_and_icon():
    out = sh(['pactl', 'get-sink-volume', '@DEFAULT_SINK@'])
    vol = int(re.search(r'(\d+)%', out).group(1))
    muted = sh(['pactl', 'get-sink-mute', '@DEFAULT_SINK@']).endswith('yes')
    icons = ["", "", ""]
    icon = "" if muted else icons[min(vol // 34, 2)] 
    return vol, icon

def rofi_pick(kind):
    short = sh(['pactl', 'list', 'short', kind]).splitlines()
    choices = []
    for line in short:
        name = line.split()[1]
        choices.append(f'{nice_name(name)}\t{name}')
    launcher = os.environ.get('AUDIO_PICKER', 'rofi -dmenu -p')
    selection = sh(launcher.split() + [kind[:-1]], '\n'.join(choices))
    if selection:
        name = selection.split('\t')[1]
        sh(['pactl', 'set-default-' + kind[:-1], node])

if len(sys.argv) > 1 and sys.argv[1] in ('pick-sink', 'pick-source'):
    rofi_pick('sinks' if 'sink' in sys.argv[1] else 'sources')
    sys.exit(0)

vol, icon = volume_and_icon()
out_name = nice_name('@DEFAULT_SINK@')
mic_name = nice_name('@DEFAULT_SOURCE@')
print(json.dumps({
    "text": f"{vol}% {icon}",
    "tooltip": f"{out_name}\nMic: {mic_name}"
}))
