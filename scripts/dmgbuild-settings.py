import os

app_path = defines["app"]
background_path = defines["background"]

format = "UDZO"
filesystem = "HFS+"

files = [app_path]
symlinks = {"Applications": "/Applications"}

background = background_path
window_rect = ((120, 120), (512, 280))
icon_size = 128
text_size = 12

app_name = os.path.basename(app_path)
icon_locations = {
    app_name: (130, 122),
    "Applications": (382, 122),
}
