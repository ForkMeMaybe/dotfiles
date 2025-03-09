import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, hook, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.dgroups import simple_key_binder
from time import sleep

mod = "mod4"
mod1 = "mod1"
terminal = "alacritty"


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# Define a function to close all windows in a specified workspace
def close_all_windows_in_workspace(qtile, workspace_name):
    group = qtile.groups_map.get(workspace_name)
    if group:
        for window in group.windows:
            window.kill()


# █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █▀
# █░█ ██▄ ░█░ █▄█ █ █░▀█y █▄▀ ▄█


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key(
        [mod],
        "b",
        lazy.hide_show_bar(position="all"),
        desc="Toggles the bar to show/hide",
    ),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key(
        [mod, "shift"],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [mod, "shift"],
        "r",
        lazy.spawncmd(),
        desc="Spawn a command using a prompt widget",
    ),
    # Volume up
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"),
    ),
    # Volume down
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
    ),
    # Mute/Unmute
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="playerctl"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="playerctl"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="playerctl"),
    # Volume up
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 2 set 'Master' 5%+")),
    # Volume down
    # Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 2 set 'Master' 5%-")),
    # Mute/Unmute
    # Key([], "XF86AudioMute", lazy.spawn("amixer -c 2 set 'Master' toggle")),
    # Brightness down (F7 key)
    Key(
        [],
        "F7",
        lazy.spawn(
            "bash -c 'light -U 5 && notify-send -u normal -i /home/odd/.config/dunst/icons/brightness-decrease.png \" \"'"
        ),
        desc="Turn display backlight down",
    ),
    # Brightness up (F9 Key)
    Key(
        [],
        "F8",
        lazy.spawn(
            "bash -c 'light -A 5 && notify-send -u normal -i /home/odd/.config/dunst/icons/brightness-increase.png \" \"'"
        ),
        desc="Turn display backlight down",
    ),
    # Keyboard Brightness
    Key(
        [],
        "F2",
        lazy.spawn(
            "bash -c 'echo 0 > /sys/class/leds/asus::kbd_backlight/brightness && notify-send -u normal -i /home/odd/.config/dunst/icons/keyboard-backlight-off.png \" \"'"
        ),
        desc="Turn keyboard backlight down",
    ),
    Key(
        [],
        "F3",
        lazy.spawn(
            "bash -c 'echo 1 > /sys/class/leds/asus::kbd_backlight/brightness && notify-send -u normal -i /home/odd/.config/dunst/icons/keyboard-backlight-on.png \" \"'"
        ),
        desc="Turn keyboard backlight up",
    ),
    Key(
        [mod],
        "r",
        lazy.spawn("sh -c ~/.config/rofi/scripts/launcher"),
        desc="Spawn a command using a prompt widget",
    ),
    Key([mod], "p", lazy.spawn("sh -c ~/.config/rofi/scripts/power"), desc="powermenu"),
    Key(
        [mod],
        "t",
        lazy.spawn("sh -c ~/.config/rofi/scripts/theme_switcher"),
        desc="theme_switcher",
    ),
    # Key([mod], "h", lazy.spawn("roficlip"), desc="clipboard"),
    # Thunar
    Key([mod], "e", lazy.spawn("thunar"), desc="Open Thunar file manager"),
    # Rofi
    # Key([mod], "r", lazy.spawn("rofi -show drun -theme ~/.config/rofi/launchers/type-6/style-5.rasi"), desc="Open rofi drun mode"),
    # Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Open rofi drun mode"),
    # Key([mod], "b", lazy.spawn(os.path.expanduser("~/.config/rofi/applets/bin/powermenu.sh")), desc="Brightness control")
    # Run save_dotfiles.sh script
    Key([mod, "shift"], "s", lazy.spawn("/home/odd/repos/dotfiles/save_dotfiles.sh")),
    # i3lock Lock Screen
    Key([mod1], "l", lazy.spawn("i3lock-fancy")),
    # Flame-Shot
    Key([mod], "s", lazy.spawn("flameshot gui"), desc="Open Flame-Shot GUI"),
    # Close all windows in workspace "1"
    Key(
        [mod1, "shift"],
        "1",
        lazy.function(close_all_windows_in_workspace, "1"),
        desc="Close all windows in workspace 1",
    ),
    # Close all windows in workspace "2"
    Key(
        [mod1, "shift"],
        "2",
        lazy.function(close_all_windows_in_workspace, "2"),
        desc="Close all windows in workspace 2",
    ),
    # Close all windows in workspace "3"
    Key(
        [mod1, "shift"],
        "3",
        lazy.function(close_all_windows_in_workspace, "3"),
        desc="Close all windows in workspace 3",
    ),
    # Close all windows in workspace "4"
    Key(
        [mod1, "shift"],
        "4",
        lazy.function(close_all_windows_in_workspace, "4"),
        desc="Close all windows in workspace 4",
    ),
    # Close all windows in workspace "5"
    Key(
        [mod1, "shift"],
        "5",
        lazy.function(close_all_windows_in_workspace, "5"),
        desc="Close all windows in workspace 5",
    ),
    # Close all windows in workspace "6"
    Key(
        [mod1, "shift"],
        "6",
        lazy.function(close_all_windows_in_workspace, "6"),
        desc="Close all windows in workspace 6",
    ),
    # Close all windows in workspace "7"
    Key(
        [mod1, "shift"],
        "7",
        lazy.function(close_all_windows_in_workspace, "7"),
        desc="Close all windows in workspace 7",
    ),
    # Close all windows in workspace "8"
    Key(
        [mod1, "shift"],
        "8",
        lazy.function(close_all_windows_in_workspace, "8"),
        desc="Close all windows in workspace 8",
    ),
    # Close all windows in workspace "9"
    Key(
        [mod1, "shift"],
        "9",
        lazy.function(close_all_windows_in_workspace, "9"),
        desc="Close all windows in workspace 9",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# groups = [Group(i) for i in "123456789"]
groups = [Group(f"{i+1}", label="") for i in range(9)]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

lay_config = {
    "border_width": 0,
    "margin": 9,
    "border_focus": "3b4252",
    "border_normal": "3b4252",
    "font": "FiraCode Nerd Font",
    "grow_amount": 2,
}

layouts = [
    # layout.MonadWide(**lay_config),
    layout.Bsp(**lay_config, fair=False, border_on_single=True),
    layout.Columns(
        **lay_config,
        border_on_single=True,
        num_columns=2,
        split=False,
    ),
    # Plasma(lay_config, border_normal_fixed='#3b4252', border_focus_fixed='#3b4252', border_width_single=3),
    # layout.RatioTile(**lay_config),
    # layout.VerticalTile(**lay_config),
    # layout.Matrix(**lay_config, columns=3),
    # layout.Zoomy(**lay_config),
    # layout.Slice(**lay_config, width=1920, fallback=layout.TreeTab(), match=Match(wm_class="joplin"), side="right"),
    layout.MonadTall(**lay_config),
    layout.Tile(shift_windows=True, **lay_config),
    # layout.Stack(num_stacks=2, **lay_config),
    layout.Floating(**lay_config),
    layout.Max(**lay_config),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = [widget_defaults.copy()]


def search():
    qtile.cmd_spawn("rofi -show drun")


def power():
    qtile.cmd_spawn("sh -c ~/.config/rofi/scripts/power")


# █▄▄ ▄▀█ █▀█
# █▄█ █▀█ █▀▄

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(
                    length=15,
                    background="#282738",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/launch_Icon.png",
                    margin=2,
                    background="#282738",
                    mouse_callbacks={"Button1": power},
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/6.png",
                ),
                widget.GroupBox(
                    font="JetBrainsMono Nerd Font",
                    fontsize=24,
                    borderwidth=3,
                    highlight_method="block",
                    active="#CAA9E0",
                    block_highlight_text_color="#91B1F0",
                    highlight_color="#353446",
                    inactive="#282738",
                    foreground="#4B427E",
                    background="#353446",
                    this_current_screen_border="#353446",
                    this_screen_border="#353446",
                    other_current_screen_border="#353446",
                    other_screen_border="#353446",
                    urgent_border="#353446",
                    rounded=True,
                    disable_drag=True,
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/1.png",
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=["~/.config/qtile/Assets/layout"],
                    background="#353446",
                    scale=0.50,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/5.png",
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#282738",
                    foreground="#CAA9E0",
                    mouse_callbacks={"Button1": search},
                ),
                widget.TextBox(
                    fmt="Search",
                    background="#282738",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    foreground="#CAA9E0",
                    mouse_callbacks={"Button1": search},
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/4.png",
                ),
                widget.WindowName(
                    background="#353446",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    empty_group_string="Desktop",
                    max_chars=130,
                    foreground="#CAA9E0",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/3.png",
                ),
                widget.Systray(
                    background="#282738",
                    fontsize=2,
                ),
                widget.TextBox(
                    text=" ",
                    background="#282738",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/6.png",
                    background="#353446",
                ),
                widget.TextBox(
                    text="",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#353446",
                    foreground="#CAA9E0",
                ),
                widget.Memory(
                    background="#353446",
                    format="{MemUsed: .0f}{mm}",
                    foreground="#CAA9E0",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    update_interval=5,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(terminal + " -e btop")
                    },
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/2.png",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.TextBox(
                    text="",
                    background="#353446",
                    foreground="#CAA9E0",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                ),
                widget.CPU(
                    background="#353446",
                    fontsize=13,
                    format=" CPU: {load_percent}%",
                    foreground="#CAA9E0",
                    font="JetBrainsMono Nerd Font Bold",
                    update_interval=5,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/2.png",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.TextBox(
                    text=" ",
                    background="#353446",
                    foreground="#CAA9E0",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                ),
                widget.DF(
                    background="#353446",
                    foreground="#CAA9E0",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    update_interval=60,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(terminal + " -e df")
                    },
                    partition="/",
                    # format = '[{p}] {uf}{m} ({r:.0f}%)',
                    format="{uf}{m} Free",
                    fmt=" DISK: {}",
                    visible_on_warn=False,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/2.png",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.TextBox(
                    text=" ",
                    background="#353446",
                    foreground="#CAA9E0",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                ),
                widget.Volume(
                    background="#353446",
                    foreground="#CAA9E0",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/2.png",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#353446",
                    foreground="#CAA9E0",
                ),
                widget.Battery(
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    background="#353446",
                    foreground="#CAA9E0",
                    format="{percent:2.0%}",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/2.png",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#353446",
                    foreground="#CAA9E0",
                ),
                widget.Net(
                    background="#353446",
                    foreground="#CAA9E0",
                    fontsize=13,
                    font="JetBrainsMono Nerd Font Bold",
                    format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
                    interface="wlp3s0",
                ),
                widget.Image(
                    filename="~/.config/qtile/Assets/5.png",
                    background="#353446",
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#282738",
                    foreground="#CAA9E0",
                ),
                widget.Clock(
                    format="%I:%M %p",
                    background="#282738",
                    foreground="#CAA9E0",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                ),
                widget.Spacer(
                    length=18,
                    background="#282738",
                ),
            ],
            30,
            border_color="#282738",
            border_width=[0, 0, 0, 0],
            margin=[15, 60, 6, 60],
        ),
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


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#1F1D2E",
    border_normal="#1F1D2E",
    border_width=0,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call(home)
