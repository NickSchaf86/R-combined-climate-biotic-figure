setwd("C:/Users/schafstall/Desktop/R Paleo/Paleoclimate reconstructions/Input files/")

library(dplyr)
library(readxl)
library(ggplot2)
library(tidyr)

Climdata <- read.csv("bio_CHELSA.csv")
Climdata2 <- Climdata %>% filter(cal.yr.BP <= 8000)

MAT <- ggplot(Climdata2, aes(x = cal.yr.BP, y = bio01)) +
  geom_line(color = "gold1")

PREC <- ggplot(Climdata2, aes(x = cal.yr.BP, y = bio16)) +
  geom_line(color = "darkblue") +
  geom_line(aes(y = bio17), color = "lightblue")

### now to the second harder part, with collected data

Biodata <- read.csv("Paleodata_Blata.csv")



### stack all on top of each other in a grid
library(gridExtra)
grid.arrange(MAT,PREC, nrow=2)
