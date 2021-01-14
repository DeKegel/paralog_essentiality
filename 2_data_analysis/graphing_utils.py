import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib as mpl

# rcParams can be set in this opts list'
default_opts = {'axes.spines.top': False, 'axes.spines.right': False, 'grid.color': 'lightgray', 'axes.axisbelow': True,
                'axes.grid': False, 'axes.facecolor': 'white', 'axes.edgecolor': 1, 'grid.linewidth': 0.8,
                'axes.edgecolor': '0', 'xtick.bottom': True, 'ytick.left': True, 'axes.linewidth' : 1, 'font.size': 12,
                'axes.labelsize': 12, 'xtick.labelsize' : 11, 'ytick.labelsize' : 11, 'legend.fontsize': 12, 
                'legend.title_fontsize': 12, 'axes.titlesize': 14, 'pdf.fonttype': 42, 'svg.fonttype': 'none'
               }

slides_params = {
    'axes.labelsize': 16, 
    'xtick.labelsize': 14, 
    'ytick.labelsize': 14, 
    'legend.fontsize':15.5, 
    'legend.title_fontsize': 16,
    'lines.linewidth':2
}

mpl.rcParams.update(default_opts)

def get_color_palette(i):
    if i == 1: # blue, grey, orange
        return [sns.color_palette('colorblind')[0], sns.color_palette('colorblind')[7], sns.color_palette('colorblind')[3]]
    if i == 2: # light blue, yellow
        return [sns.color_palette('colorblind')[8], sns.color_palette('colorblind')[9]]
    if i == 3: # orange
        return [sns.color_palette('colorblind')[3]]
    if i == 4: # pink and green
        return [sns.color_palette('colorblind')[4], sns.color_palette('colorblind')[2]]
    if i == 5: # green and pink
        return [sns.color_palette('colorblind')[2], sns.color_palette('colorblind')[4]]
    if i == 6: # pink
        return [sns.color_palette('colorblind')[4]]