#!/usr/bin/env python3

import sys, json
from dbus import SessionBus, Interface
from dbus.exceptions import DBusException

Bus = SessionBus()

PLAYER_BUS = 'org.mpris.MediaPlayer2.spotify'
PLAYER_PATH = '/org/mpris/MediaPlayer2'
PLAYER_IFACE = 'org.mpris.MediaPlayer2.Player'
PROPS_IFACE = 'org.freedesktop.DBus.Properties'

def get_player():
    try:
        return Bus.get_object(PLAYER_BUS, PLAYER_PATH)
    except DBusException:
        return None

def status():
    p = get_player()
    if not p:
        print(json.dumps({
            "state":"Stopped",
            "title":"Spotify not running",
            "icon":""
        }))
        return
    props = Interface(p, PROPS_IFACE)
    playback = props.Get(PLAYER_IFACE, 'PlaybackStatus')
    meta = props.Get(PLAYER_IFACE, 'Metadata')
    artist = meta.get('xesam:artist', [''])[0]
    title = meta.get('xesam:title', '')
    icon = '' if playback=='Paused' else ''
    print(json.dumps({
        "state": playback,
        "icon": icon,
        "title": f"{artist} - {title}"
    }))

def playpause():
    p = get_player()
    if p:
        Interface(p, PLAYER_IFACE).PlayPause()

def next_track():
    p = get_player()
    if p:
        Interface(p, PLAYER_IFACE).Next()

def prev_track():
    p = get_player()
    if p:
        Interface(p, PLAYER_IFACE).Previous()

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'status'
    if cmd == 'playpause': playpause()
    elif cmd == 'next': next_track()
    elif cmd == 'prev': prev_track()
    else: status()
