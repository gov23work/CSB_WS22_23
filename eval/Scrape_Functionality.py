# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import matplotlib.pyplot as plt
import pandas as pd

def plot_data(z):
    df = pd.read_csv("/Users/tdockenf/Documents/Average.csv")
    #create seperate groups
    ax = plt.subplot(111)
    df_alt = df.query("`Z` == @z and `X` ==5")
    ax.plot(df_alt["Y"], df_alt["Scrape"], 'bo', label="5 second scrape interval")
    df_alt = df.query("`Z` == @z and `X` ==2")
    ax.plot(df_alt["Y"], df_alt["Scrape"], 'ro', label="2 second scrape interval")
    df_alt = df.query("`Z` == @z and `X` ==1")
    ax.plot(df_alt["Y"], df_alt["Scrape"], 'go', label="1 second scrape interval")
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    plt.ylabel("% of functional scrapes / data completeness")
    plt.xlabel("# of Node exporters")
    plt.title("Functional scrape percentage with "+str(z)+" extra metrics")
    plt.show()
# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    plot_data(100000)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
