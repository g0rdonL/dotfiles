from libqtile.config import Key, Screen, Group, Drag, Click, Match, ScratchPad, DropDown
from libqtile.lazy import lazy

from libqtile import layout, bar, widget, extension, qtile, hook

from libqtile.backend.base import Window

from libqtile.utils import send_notification


from custom import CryptoTicker, Weather, Net, ThermalSensor


# import geocoder
import os
import subprocess


mod = "mod4"
term = "alacritty"
tui = "alacritty -e env COLUMNS= LINES= "


# g = geocoder.ip("me")
g = {}
location = {}
if g:
    location["lat"] = str(g.lat)
    location["lon"] = str(g.lng)
    location["city"] = g.city
    location["country"] = g.city
else:
    # location["lat"] = "22.3193"
    # location["lon"] = "114.194"
    location["city"] = "Hong Kong"
    location["country"] = ""


@hook.subscribe.startup_once
def autostart():
    qtile.cmd_spawn(
        "xidlehook --not-when-audio --not-when-fullscreen --timer 900 '/usr/bin/slock' ''"
    ),
    qtile.cmd_spawn("brave --app-id=majiogicmcnmdhhlgmkahaleckhjbmlk"),
    qtile.cmd_spawn("picom --experimental-backends"),
    qtile.cmd_spawn("nm-applet"),
    qtile.cmd_spawn("blueman-applet"),
    qtile.cmd_spawn("feh --bg-fill ~/Pictures/wallpaper.png"),
    qtile.cmd_spawn("dunst"),
    qtile.cmd_spawn("fusama -d"),
    qtile.cmd_spawn("/usr/bin/lxpolkit"),
    qtile.cmd_spawn("sudo tzupdate"),
    qtile.cmd_spawn("brave --app-id=maonlnecdeecdljpahhnnlmhbmalehlm"),
    qtile.cmd_spawn("brave --app-id=nohnjepjbknpfcfhdamjoliblacghbna"),
    qtile.cmd_spawn("insync start"),
    qtile.cmd_spawn("brave --app-id=hnpfjngllnobngcgfapefoaidbinmjnm"),
    qtile.cmd_spawn(f"redshift-gtk -l {location['lat']}:{location['lon']}")


@hook.subscribe.client_new
def toggle_fullscreen_off(client: Window) -> None:
    """Toggle fullscreen off in case there's any window fullscreened in the group"""
    try:
        group = client.group
    except AttributeError:
        return

    if group is None:
        assert qtile is not None
        group = qtile.current_group

    for window in group.windows:
        if window.fullscreen:
            window.toggle_fullscreen()


@hook.subscribe.current_screen_change
def warp_cursor() -> None:
    """Warp cursor to focused screen"""
    assert qtile is not None
    qtile.warp_to_screen()


@lazy.function
def toggle_microphone():
    """Run the toggle command and then send notification to report status of microphone"""
    try:
        subprocess.call(["amixer set Capture toggle"], shell=True)

        message = subprocess.check_output(["amixer sget Capture"], shell=True).decode(
            "utf-8"
        )

        if "off" in message:
            message = "Muted"

        elif "on" in message:
            message = "Unmuted"

        title = "Microphone"
        send_notification(title, message, timeout=2500, urgent=False)

    except subprocess.CalledProcessError:
        return


def get_color(key):
    colors = dict(
        primary="#bd93f9",
        foreground="#f8f8f2",
        background="#282a36",
        grey="#44475a",
        green="#50fa7b",
        cyan="#8be9fd",
        pink="#ff79c6",
        yellow="#f1fa8c",
        orange="#ffb86c",
    )
    return colors[key]


keys = [
    # -----------------------------------*----------------------------------- #
    # ---------------------------Launch Applications------------------------- #
    # -----------------------------------*----------------------------------- #
    # GUI applications
    Key([mod], "b", lazy.spawn("timeshift-launcher")),
    Key([mod], "g", lazy.spawn("lutris")),
    Key([mod], "i", lazy.spawn("insomnia")),
    Key([mod], "t", lazy.spawn("tableplus")),
    Key([mod], "v", lazy.spawn("pavucontrol")),
    Key([mod], "c", lazy.spawn("emacsclient -c")),
    Key([mod], "r", lazy.spawn("emacsclient --eval '(emacs-everywhere)'")),
    Key([mod], "semicolon", lazy.spawn("emacsclient -c")),
    Key([mod], "w", lazy.spawn("brave")),
    Key([mod, "shift"], "w", lazy.spawn("firefox")),
    Key(
        [mod],
        "m",
        lazy.group["mailspring"].toscreen(toggle=False),
        lazy.spawn("mailspring"),
    ),
    Key(
        [mod],
        "p",
        lazy.spawn("killall picom"),
        lazy.spawn("picom --experimental-backends"),
    ),
    Key([mod], "y", lazy.spawn("celluloid --mpv-options=--fs")),
    # Scratchpads
    Key(
        [mod],
        "s",
        lazy.group["scratchpad"].dropdown_toggle("conky"),
    ),
    Key([mod], "e", lazy.group["scratchpad"].dropdown_toggle("ranger")),
    # CLI applications
    Key([mod], "Return", lazy.spawn(term)),
    # rofi menus
    Key([mod], "d", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "d", lazy.spawn("rofi -show run")),
    Key(
        [mod, "control"],
        "v",
        lazy.run_extension(
            extension.CommandSet(
                commands={
                    " Connect to Windows LTSC": 'virsh start win & virt-viewer -f --domain-name win & notify-send " Windows VM connected"',
                    " Disconnect from Windows LTSC": 'virsh managedsave win & killall virt-viewer & killall libvirtd & notify-send " Windows VM suspended"',
                    " Connect to Manjaro": 'virsh start majaro & virt-viewer -f --domain-name manjaro & notify-send "  Manjaro VM connected"',
                    " Disconnect from Manjaro": 'virsh managedsave manjaro & killall virt-viewer & killall libvirtd & notify-send " Manjaro VM suspended"',
                },
                dmenu_prompt="Virtual Machines",
                dmenu_ignorecase=True,
            )
        ),
    ),
    Key(
        [mod, "control"],
        "r",
        lazy.run_extension(
            extension.CommandSet(
                commands={
                    " Connect to FXPrimus VPS": 'remmina -c ~/.local/share/remmina/vps_rdp_fxprimus_3-217-236-145.remmina & notify-send "Remote connected"',
                    " Disconnect all remote connections": 'remmina -q & notify-send "Remote disconnected"',
                },
                dmenu_prompt="Remote Connections",
                dmenu_ignorecase=True,
            )
        ),
    ),
    Key([mod, "control"], "n", lazy.spawn("networkmanager_dmenu")),
    Key(
        [mod, "control"],
        "c",
        lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort"),
    ),
    Key(
        [mod, "control"],
        "s",
        lazy.spawn([os.path.expanduser("~/.config/rofi/scripts/monitor-layout.sh")]),
    ),
    Key([mod, "control"], "b", lazy.spawn("rofi-bluetooth")),
    Key([], "Print", lazy.spawn("rofi-screenshot")),
    Key([mod], "Print", lazy.spawn("rofi-screenshot -s")),
    Key(
        [mod, "control"],
        "p",
        lazy.run_extension(
            extension.CommandSet(
                commands={
                    "Lock": "slock",
                    "Suspend": "systemctl suspend",
                    "Shutdown": "systemctl poweroff",
                    "Reboot": "systemctl reboot",
                    "Logout": lazy.shutdown(),
                },
                dmenu_prompt="Power",
                dmenu_ignorecase=True,
            )
        ),
    ),
    # -----------------------------------*----------------------------------- #
    # --------------------------Window Manipulation-------------------------- #
    # -----------------------------------*----------------------------------- #
    # Layout
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "Tab", lazy.prev_layout()),
    Key([mod, "shift"], "q", lazy.window.kill()),
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    # Move windows up or down in current stack
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    # Grow windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod], "space", lazy.layout.next()),
    # Window sizes
    Key([mod], "h", lazy.layout.grow(), lazy.layout.increase_nmaster()),
    Key([mod], "l", lazy.layout.shrink(), lazy.layout.decrease_nmaster()),
    Key([mod], "n", lazy.layout.normalize()),
    # Key([mod], 'm', lazy.layout.maximize()),
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    # Monitors
    Key([mod], "period", lazy.next_screen()),
    Key([mod], "comma", lazy.prev_screen()),
    Key([mod, "shift"], "space", lazy.layout.rotate(), lazy.layout.flip()),
    Key([mod], "space", lazy.layout.next()),
    # -----------------------------------*----------------------------------- #
    # ------------------------------XF86 Buttons----------------------------- #
    # -----------------------------------*----------------------------------- #
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.widget["volume"].increase_vol()),
    Key([], "XF86AudioLowerVolume", lazy.widget["volume"].decrease_vol()),
    Key([], "XF86AudioMute", lazy.widget["volume"].mute()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),
    # -----------------------------------*----------------------------------- #
    # ------------------------------Notifications---------------------------- #
    # -----------------------------------*----------------------------------- #
    Key([mod], "x", lazy.spawn("dunstctl close-all")),
    Key([mod], "z", lazy.spawn("dunstctl history-pop")),
]

groups = [
    Group("1", label="", layout="ratiotile"),
    Group("2", label="", layout="monadtall"),
    Group(
        "3",
        label="",
        layout="ratiotile",
        matches=[
            Match(wm_class="crx_majiogicmcnmdhhlgmkahaleckhjbmlk"),
            Match(wm_class="crx_maonlnecdeecdljpahhnnlmhbmalehlm"),
            Match(wm_class="crx_nohnjepjbknpfcfhdamjoliblacghbna"),
            Match(wm_class="crx_hnpfjngllnobngcgfapefoaidbinmjnm"),
        ],
    ),
    Group("4", label="", layout="monadtall"),
    Group(
        "5",
        label="",
        layout="monadtall",
        spawn="spotify",
        matches=[Match(wm_class="spotify")],
    ),
    Group(
        "6",
        label="",
        layout="monadtall",
        spawn="ticktick",
        matches=[Match(wm_class="ticktick")],
    ),
    Group(
        "7",
        label="",
        layout="monadtall",
        spawn="mailspring",
        matches=[Match(wm_class="mailspring")],
    ),
    Group(
        "8",
        label="",
        layout="monadtall",
        spawn="discord-canary",
        matches=[Match(wm_class="discord-canary")],
    ),
    Group("9", label="", layout="monadtall"),
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "ranger",
                tui + "ranger",
                opacity=0.88,
                height=0.5,
                width=0.5,
                x=0.25,
                y=0.25,
            ),
            DropDown(
                "bashtop",
                tui + "bashtop",
                opacity=0.88,
                height=0.6,
                width=0.6,
                x=0.2,
                y=0.2,
            ),
        ],
    ),
]


for group in groups[:-1]:
    name = group.name
    keys.extend(
        [
            Key([mod], name, lazy.group[name].toscreen(toggle=True)),
            Key([mod, "shift"], name, lazy.window.togroup(name, switch_group=True)),
        ]
    )

layout_theme = dict(
    border_width=3,
    margin=5,
    border_focus=get_color("primary"),
    border_normal=get_color("grey"),
)

layouts = [
    layout.Stack(**layout_theme, num_stacks=1),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.RatioTile(**layout_theme),
    # layout.Max(),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.TreeTab(
    #     **layout_theme,
    #     active_bg=get_color('primary'),
    #     active_fg=get_color('foreground'),
    #     bg_color=get_color('background'),
    #     inactive_bg=get_color('background'),
    #     inactive_fg=get_color('yellow'),
    #     section_fontsize=0,
    #     section_top=0,
    #     section_left=0,
    #     section_padding=0,
    #     padding_x=0,
    #     padding_y=0,
    #     padding_left=0,
    #     vspace=0,
    #     panel_width=50,
    #     previous_on_rm=True,
    # ),
    # layout.VerticalTile(),
    # layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="DejaVu Sans Mono, Font Awesome 6 Free",
    fontsize=12,
    padding=10,
    foreground=get_color("foreground"),
)

extension_defaults = widget_defaults.copy()


def playerctl_poll():
    status = subprocess.getoutput("playerctl status -p 'spotify,*'")
    if status == "Paused":
        return "  "
    elif status == "Playing":
        artist = subprocess.getoutput(
            "playerctl metadata -p 'spotify,*' | grep 'xesam:artist' | awk '{$1=$2=\"\"; print $0}'"
        ).strip()
        title = (
            subprocess.getoutput(
                "playerctl metadata -p 'spotify,*' | grep 'xesam:title' | awk '{$1=$2=\"\"; print $0}'"
            )
            .strip()
            .replace("(", "-")
            .replace("[", "-")
            .split(" -")[0]
        )
        return f" {artist} - {title}"
    else:
        return ""


def get_widgets():
    return [
        widget.CurrentLayoutIcon(background=get_color("grey"), scale=0.35, padding=5),
        widget.GroupBox(
            urgent_alert_method="line",
            highlight_method="line",
            highlight_color=[get_color("grey"), get_color("grey")],
            this_current_screen_border=get_color("primary"),
            other_current_screen_border=get_color("cyan"),
            this_screen_border=get_color("yellow"),
            other_screen_border=get_color("cyan"),
            inactive=get_color("yellow"),
            disable_drag=True,
            borderwidth=3,
            spacing=0,
            padding_x=10,
        ),
        widget.WindowName(fontsize=0),
        widget.CheckUpdates(
            custom_command="checkupdates && paru -Qua 2>/dev/null",
            colour_have_updates=get_color("primary"),
            display_format=" {updates:>2}",
        ),
        widget.GenPollText(
            func=playerctl_poll,
            mouse_callbacks={
                "Button1": lazy.spawn(
                    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
                ),
                "Button2": lazy.spawn(
                    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
                ),
                "Button3": lazy.spawn(
                    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
                ),
            },
            update_interval=1,
            markup=False,
            foreground=get_color("green"),
        ),
        CryptoTicker(
            currency="usd",
            symbol="$",
            cryptos=dict(
                BTC="bitcoin",
                ETH="ethereum",
                BNB="bnb",
                ADA="cardano",
                AVAX="avalanche",
                MATIC="polygon",
                ATOM="cosmos",
                VET="vechain",
                AXS="axie-infinity",
                FTM="fantom",
                RUNE="thorchain",
                NEXO="nexo",
                AR="arweave",
                KDA="kadena",
                SLP="smooth-love-potion",
                DOME="everdome",
                TITANO="titano",
                THOR="thor",
            ),
            format="{crypto}:{symbol}{amount}",
            update_interval=60,
            foreground=get_color("yellow"),
        ),
        Weather(
            location={f"{location['city']}": f"{location['city']}"},
            format="%l %t %c",
            foreground=get_color("pink"),
        ),
        Net(
            foreground=get_color("orange"),
            format="{down}↓↑{up}",
            # prefix="M",
            padding=5,
        ),
        ThermalSensor(tag_sensor="Package id 0", foreground=get_color("cyan")),
        widget.Memory(format=" {MemPercent:2.0f}%", foreground=get_color("primary")),
        widget.NvidiaSensors(format=" {temp}°C", foreground=get_color("green")),
        widget.Backlight(
            format=" {percent:2.0%}",
            foreground=get_color("pink"),
            backlight_name="intel_backlight",
        ),
        widget.TextBox(text="  ", foreground=get_color("yellow"), padding=3),
        widget.Volume(
            padding=0,
            foreground=get_color("yellow"),
            step=5,
        ),
        widget.Spacer(
            length=10,
        ),
        widget.Battery(
            format="{char} {percent:2.0%}",
            foreground=get_color("green"),
            unknown_char="",
            charge_char="",
            empty_char="",
            discharge_char="",
            full_char="",
            low_percentage=0.2,
            notify_below=0.2,
        ),
        widget.Clock(foreground=get_color("orange"), format="%d %b %a %l:%M%p"),
        widget.Systray(),
        widget.Spacer(length=10),
    ]


screens = [
    Screen(
        top=bar.Bar(
            get_widgets(),
            32,
            background=get_color("background"),
        )
    ),
    Screen(
        top=bar.Bar(
            get_widgets()[:11] + get_widgets()[12:-2],
            32,
            background=get_color("background"),
        )
    ),
]
# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        Match(wm_type="utility"),
        Match(wm_type="toolbar"),
        Match(wm_type="splash"),
        Match(wm_type="dialog"),
        Match(wm_class="file_progress"),
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(func=lambda c: "Emacs Everywhere" in c.name),
        Match(func=lambda c: c.has_fixed_size()),
    ],
    **layout_theme,
)
auto_fullscreen = True
bring_front_click = False
focus_on_window_activation = "smart"
floating_types = [
    "notification",
    "toolbar",
    "splash",
    "dialog",
    "utility",
    "menu",
    "dropdown_menu",
    "popup_menu",
    "tooltip,dock",
]
wmname = "LG3D"
