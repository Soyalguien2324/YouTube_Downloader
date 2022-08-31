from rich.console import Console
#from rich.progress_bar import ProgressBar
from rich.table import Table
from rich.prompt import Prompt, Confirm
from rich.panel import Panel
import os
from enum import Enum

class DistroCode(Enum):
    Arch = 1
    Debian = 2
    Fedora = 3




console = Console()

a = Confirm.ask("[verbose_mode]Do you want to print all the outputs?", choices=['y','n'])
if a:
    verbose_mode=1
else:
    verbose_mode=0



if verbose_mode:
    console.print(Panel(':nut_and_bolt: [cyan]Youtube Video Downloader[/] (verbose)'), justify="center")
else:
    console.print(Panel(':clapper: [cyan]Youtube Video Downloader[/]'), justify='center')

def take_distro_input ():
    distro = Prompt.ask("Enter the Distro Code ", choices=['1', '2', '3'])
    distro = int(distro)
    return distro



table = Table(title="Enter Your Distro Code")

table.add_column("Distro Code", justify="center", style="red")
table.add_column("Distro Based on", justify="center", style="green")
table.add_column("Eg.", justify="left")

table.add_row("1", "Arch", "Arch Linux, Garuda, Endevour, Manjaro")
table.add_row("2", "Debian", "Ubuntu, Debian")
table.add_row("3","Red Hat", "RHEL, Fedora")


console.print(table, justify='center')

# taking distro input
distro = take_distro_input()
distro_name = DistroCode(distro).name

# distro code
if verbose_mode:
    console.log(f'users distro : {distro_name}')


# fullfill requirements
os.system(f'bash requirements.sh {distro} {verbose_mode}')


# take link input
yt_link = console.input(':musical_note: enter [blue]link[/]:')

# downloading message
if verbose_mode:
    console.log('starting download.')
console.print(Panel(f':carousel_horse: Downloading Video'))

# download the video
os.system(f'bash start_download.sh {yt_link} {verbose_mode}')


console.print(Panel('Video Downloaded in :open_file_folder: [cyan]~/Downloads/YT-Downloads[/]'), justify="center")
