from rich.console import Console
#from rich.progress_bar import ProgressBar
from rich.table import Table
from rich.prompt import Prompt, Confirm
from rich.panel import Panel
from rich.padding import Padding
import os


console = Console()

a = Confirm.ask("Do you want the detailed information?", choices=['y','n'])
if a:
    verbose_mode=1
else:
    verbose_mode=0



if verbose_mode:
    console.print(Panel('[cyan]Youtube Video Downloader[/] (verbose)'), justify="center")
else:
    console.print(Panel('[cyan]Youtube Video Downloader[/]'), justify='center')

def take_distro_input ():
    distro = Prompt.ask("Enter the Distro Code: ", choices=['1', '2', '3'])
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


# distro code
if verbose_mode:
    console.log(f'entered distro code : {distro}')


# fullfill requirements
os.system(f'bash requirements.sh {distro} {verbose_mode}')


# take link input
yt_link = console.input('\nenter [blue]link[/]:-> ')


# download the video
os.system(f'bash start_download.sh {yt_link} {verbose_mode}')


# read file for name
videotitle=''
with open('./videotitle.txt', 'r') as file:
    videotitle = file.read()


# end message
console.print(Panel(f'Video Downloaded To : ~/Downloads/YT-Downloads/{videotitle}'))


os.system('rm -rf ./videotitle.txt')

