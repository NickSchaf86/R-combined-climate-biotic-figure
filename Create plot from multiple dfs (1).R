##plot multi-stacked synthesis figure with riojaPlot

#library(devtools) ##download the package,m it's not standard in R
#install_github('nsj3/riojaPlot', build_vignettes=TRUE, dependencies=TRUE)
#
# setwd("C:/Users/schafstall/Desktop/R Paleo/Paleoclimate reconstructions/Input files/")

library(rioja)
library(riojaPlot)
library(dplyr)
library(readxl)

CHELSA <- read.csv("bio_CHELSA.csv")

###first trying out the exact examples

# better to use select from dplyr package, select and rename in one go

chron <- CHELSA %>% select(cal.yr.BP)
vars <-  CHELSA %>% select(MAT=bio01, PtWQ=bio16, PtDQ=bio17)

riojaPlot(vars,chron, 
          ylabel="Age (cal yr BP)",
          #rev=TRUE,
          #horiz=TRUE,
          plot.line=TRUE, 
          plot.poly=FALSE,
          plot.bar=FALSE)

riojaPlot(vars,chron, 
          ylabel="Age (cal yr BP)",
          ymin=-50, ymax=8000, yinterval=500,
          #rev=TRUE,
          #horiz=TRUE,
          plot.line=TRUE, 
          plot.poly=FALSE,
          plot.bar=FALSE)


#The df has data until 12000 cal yr BP, but our collected data runs until ca. 7200 cal yr BP. When I limited the y-axis, the limits of the x-axis do not automatically adapt. Firstly, I would like to learn how to manually define the x-axis limits for this plot.

# x-axes extend to whole range of data
# 2 solutions
# 1 (the easiest) - trim data before plotting 

CHELSA2 <- CHELSA %>% filter(cal.yr.BP <= 8000)

chron2 <- CHELSA2 %>% select(cal.yr.BP)
vars2 <-  CHELSA2 %>% select(MAT=bio01, PtWQ=bio16, PtDQ=bio17)

riojaPlot(vars2, chron2, 
          ylabel="Age (cal yr BP)",
          ymin=-50, ymax=8000, yinterval=500,
          #rev=TRUE,
          #horiz=TRUE,
          plot.line=TRUE, 
          plot.poly=FALSE,
          plot.bar=FALSE)

# solution 2 is to specify min and max of each axis
# create a data frame of min / max values, one row for each variable,
# works only for non-percent data, but gives more control over axis limits

minmax <- data.frame(min=c(2.5, 420, 240), max=c(4.5, 680, 260))

riojaPlot(vars,chron, 
          ylabel="Age (cal yr BP)",
          ymin=-50, ymax=8000, yinterval=500,
          minmax=minmax,
          #rev=TRUE,
          #horiz=TRUE,
          plot.line=TRUE, 
          plot.poly=FALSE,
          plot.bar=FALSE)

# Secondly, I was wondering if it would be possible to plot the second and third curves (precipitation of warmest and dryest quarter) together in one plot.

# it is possible to do this but requires using a custom function to overlay a second curve.  I can show you how later when you have got the rest how you want it.

# Thirdly, I would like to plot the figure horizontally with a reversed y-axis (as in slide 36 of your manual). I couldn't find the right script for this in the example code, could you please share with me how this is done in a 'plain' script, or in my own script?

# To rotate the figure is quite a hack.  riojaPlot was designed for plotting data vertically and for plotting mostly stratigraphic data of the same type (pollen, diatoms, xrf etc) that exist in the same df.  It is possible to hack it and plot multiple datasets and rotate the figure but it requires defining custom functions to add the axis and variable names.  This would have to be separately for each df you plot.  I think it would be easier to plot the kind of diagram you want with the basic R plotting functions.

# If the data are all in the same dataframe you can use ggplot:

library(ggplot2)
library(tidyr)

# convert data from wide format to long format:

C_wide <- bind_cols(chron2, vars2) %>% pivot_longer(-cal.yr.BP, names_to="vars", values_to="value")

theme_set(theme_bw(base_size=16))
ggplot(C_wide, aes(cal.yr.BP, value)) +
   geom_line() +
   facet_grid(vars~., scales="free_y")

# This is good for a quick plot but difficult to customise the labels for a publication plot

# To have complete control I would use base graphics to create a series of line graphs.  This gives you complete control over each plot.  

# basically, split the screen into a 3 x 1 grid

par(mfrow=c(3, 1))

# then plot each variable

plot(chron2$cal.yr.BP, vars2$MAT, type="l")
plot(chron2$cal.yr.BP, vars2$PtWQ, type="l")
plot(chron2$cal.yr.BP, vars2$PtDQ, type="l")

# see ?plot for arguments to change or omit axis labels, limits etc, and ?par to change graphic parameters (margins around plot etc.)

# Instead of using par(mfrow=c(3, 1)) to position the plots you can use par(fig=) to have complete control of x and y position of the plot in the window.


