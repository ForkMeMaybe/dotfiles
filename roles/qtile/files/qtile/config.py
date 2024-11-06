# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import colors
from libqtile import bar, extension, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

mod = "mod4"
terminal = "alacritty"

# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "b", lazy.hide_show_bar(position='all'), desc="Toggles the bar to show/hide"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod, "shift"], "m", minimize_all(), desc="Toggle hide/show all windows on current group"),
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
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Volume up
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+")),
    # Volume down
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-")),
    # Mute/Unmute
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),

    # Volume up
    #Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 2 set 'Master' 5%+")),
    # Volume down
    #Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 2 set 'Master' 5%-")),
    # Mute/Unmute
    #Key([], "XF86AudioMute", lazy.spawn("amixer -c 2 set 'Master' toggle")),

     # Brightness down (F7 key)
    Key([mod], "F7", lazy.spawn("light -U 5")),  
    # Brightness up (F8 key)
    Key([mod], "F8", lazy.spawn("light -A 5")),


    # Keyboard Brightness
    Key([], "F2", lazy.spawn("bash -c 'echo 0 > /sys/class/leds/asus::kbd_backlight/brightness'"), desc="Turn keyboard backlight down"),
    Key([], "F3", lazy.spawn("bash -c 'echo 1 > /sys/class/leds/asus::kbd_backlight/brightness'"), desc="Turn keyboard backlight up"),

    # Thunar
    Key([mod], "e", lazy.spawn("thunar"), desc="Open Thunar file manager"),

    # Rofi
    #Key([mod], "r", lazy.spawn("rofi -show drun -theme ~/.config/rofi/launchers/type-6/style-5.rasi"), desc="Open rofi drun mode"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Open rofi drun mode"),
    #Key([mod], "b", lazy.spawn(os.path.expanduser("~/.config/rofi/applets/bin/powermenu.sh")), desc="Brightness control")

    Key([mod, "shift"], "s", lazy.spawn("/home/odd/repos/dotfiles/save_dotfiles.sh")),
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

#groups = [Group(i) for i in "123456789"]
groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]

group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]
#group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX",]
#group_labels = [" ", " ", " ", " ", " ", " ", " ", " ", ""]
group_layouts = ["monadtall", "monadtall", "tile", "tile", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

colors = colors.DoomOne

layout_theme = {"border_width": 2,
                "margin": 8,
                "border_focus": colors[8],
                "border_normal": colors[0]
                }

layouts = [
    # Try more layouts by unleashing below layouts.

    #layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    #layout.MonadWide(**layout_theme),
    layout.Tile(
         shift_windows=True,
         border_width = 0,
         margin = 0,
         ratio = 0.335,
         ),
    layout.Max(
         border_width = 0,
         margin = 0,
         ),
    #layout.Stack(**layout_theme, num_stacks=2),
    #layout.Columns(**layout_theme),
    #layout.TreeTab(
    #     font = "Ubuntu Bold",
    #     fontsize = 11,
    #     border_width = 0,
    #     bg_color = colors[0],
    #     active_bg = colors[8],
    #     active_fg = colors[2],
    #     inactive_bg = colors[1],
    #     inactive_fg = colors[0],
    #     padding_left = 8,
    #     padding_x = 8,
    #     padding_y = 6,
    #     sections = ["ONE", "TWO", "THREE"],
    #     section_fontsize = 10,
    #     section_fg = colors[7],
    #     section_top = 15,
    #     section_bottom = 15,
    #     level_shift = 8,
    #     vspace = 3,
    #     panel_width = 240
    #     )
    #layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Iosevka Nerd Font",
    fontsize = 12,
    padding = 0,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
		widget.Spacer(length = 3, background="#00000000",),
                widget.Image(
		         background="#00000000",
                 filename = "~/.config/qtile/icons/a.png",
                 scale = "False",
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal)},
                 margin_x = 2
                 ),
		widget.TextBox(
                 background="#00000000",
                 text = '|',
                 font = "Iosevka Nerd Font",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 18
                 ),
                widget.Prompt(
                 background="#00000000",
                 font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
                 fontsize=17,
                 foreground = colors[1]
                ),
                widget.GroupBox(
		 background="#00000000",
                 fontsize = 18,
                 margin_y = 3,
                 margin_x = 3,
                 padding_y = 0,
                 padding_x = 2,
                 borderwidth = 3,
                 active = colors[8],
                 inactive = colors[1],
                 rounded = False,
                 highlight_color = colors[2],
                 highlight_method = "line",
                 this_current_screen_border = colors[7],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[7],
                 other_screen_border = colors[4],
                 ),
                widget.TextBox(
  		 background="#00000000",
                 text = '|',
                 font = "Iosevka Nerd Font",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 18
                 ),
                widget.CurrentLayoutIcon(
		 background="#00000000",
                 foreground = colors[1],
                 padding = 4,
                 scale = 0.7,
		 fontsize = 19
                 ),
                widget.CurrentLayout(
		 background="#00000000",
                 foreground = colors[1],
                 padding = 5,
                 fontsize = 16
                 ),
                widget.TextBox(
		 background="#00000000",
                 text = '|',
                 font = "Iosevka Nerd Font",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 18
                 ),
                widget.WindowName(
		 background="#00000000",
                 foreground = colors[6],
                 max_chars = 40,
                 fontsize = 16
                 ),
		widget.TextBox(
                    text="❤",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=20,
                    foreground=colors[3],
                    decorations=[
                     BorderDecoration(
                         colour = colors[3],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
                widget.GenPollText(
		 background="#00000000",
                 fontsize = 15,
                 update_interval = 300,
                 func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
                 foreground = colors[3],
                 fmt = ' {}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[3],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
              widget.Spacer(length = 9, background="#00000000",),
	      widget.TextBox(
                    text=" ",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=20,
                    foreground=colors[4],
                    decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
              widget.CPU(
		 background="#00000000",
                 fontsize = 15,
                 format = ' CPU: {load_percent}%',
                 foreground = colors[4],
                 decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
            widget.Spacer(length = 9, background="#00000000",),
	    widget.TextBox(
                    text="",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=20,
                    foreground=colors[8],
                    decorations=[
                     BorderDecoration(
                         colour = colors[8],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
                widget.Memory(
        		 background="#00000000",
                 font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
                 fontsize = 15,
                 foreground = colors[8],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                 format = '{MemUsed: .0f}{mm}',
                 fmt = ' MEM:{} Used',
                 decorations=[
                     BorderDecoration(
                         colour = colors[8],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
                 widget.Spacer(length = 9, background="#00000000",),
		         widget.TextBox(
                    text=" ",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=18,
                    foreground=colors[5],
                    decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
                 widget.DF(
        		 background="#00000000",
        		 font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
                 fontsize = 15,
                 update_interval = 60,
                 foreground = colors[5],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
                 partition = '/',
                 #format = '[{p}] {uf}{m} ({r:.0f}%)',
                 format = '{uf}{m} Free',
                 fmt = ' DISK: {}',
                 visible_on_warn = False,
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
                widget.Spacer(length = 9, background="#00000000",),
        		widget.TextBox(
	     	    text="",
	 	        background="#00000000",
	    	    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
    		    fontsize=20, 
    		    foreground=colors[7],
    		    decorations=[
                         BorderDecoration(
                         colour = colors[7],
                         border_width = [0, 0, 2, 0],
                     )
                    ],
		        ),
                widget.Volume(
		 background="#00000000",
		 font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
                 fontsize = 15,
                 foreground = colors[7],
                 fmt = ' VOL: {}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[7],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
                widget.Spacer(length = 9, background="#00000000",),
		widget.TextBox(
                    text="⌨",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=20,
                    foreground=colors[4],
                    decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
                widget.KeyboardLayout(
		 background="#00000000",
                 fontsize = 15,
                 foreground = colors[4],
                 fmt = ' KBD: {}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
                widget.Spacer(length = 9, background="#00000000",),
		widget.TextBox(
                    text=" ",
                    background="#00000000",
                    font="Iosevka Nerd Font, Noto Color Emoji, Symbola",
                    fontsize=18,
                    foreground=colors[3],
                    decorations=[
                     BorderDecoration(
                         colour = colors[3],
                         border_width = [0, 0, 2, 0],
                     )
                ],
                ),
                widget.Clock(
		 background="#00000000",
		 font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
                 fontsize = 15,
                 foreground = colors[3],
		 format=" %a, %b %d - %I:%M %p",
                 decorations=[
                     BorderDecoration(
                         colour = colors[3],
                         border_width = [0, 0, 2, 0],
                     )
                 ],
                 ),
                widget.Spacer(length = 9, background="#00000000",),
                widget.Battery(
			font = "Iosevka Nerd Font, Noto Color Emoji, Symbola",
			background="#00000000",
                        fontsize = 15,
                        foreground = colors[1],
                        format = '  {percent:2.0%}',
                        decorations=[
                            BorderDecoration(
                                colour = colors[1],
                                border_width = [0, 0, 2, 0],
                            )
                        ],
		        low_foreground=colors[3],
		        update_interval=10,
                        ),
                widget.Spacer(length = 9, background="#00000000",),
                widget.Systray(padding = 3, background="#00000000",),
                widget.Spacer(length = 9, background="#00000000",),

                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                #widget.QuickExit(),
            ],
            24,
            background="#00000000",
            #border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
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


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
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
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)
