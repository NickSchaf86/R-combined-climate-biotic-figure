setwd("C:/xxx/")

library(dplyr)
library(readxl)
library(ggplot2)
library(tidyr)

##color palette (names): https://bookdown.org/ndphillips/YaRrr/colors.html
Climdata <- read.csv("bio_CHELSA.csv")
Climdata2 <- Climdata %>% filter(cal.yr.BP <= 8000)

MAT <- ggplot(Climdata2, aes(x = cal.yr.BP, y = bio01)) +
  geom_line(color = "gold1") +
  labs(x = " ", y = "MAT")

PREC <- ggplot(Climdata2, aes(x = cal.yr.BP, y = bio16)) +
  geom_line(color = "darkblue") +
  geom_line(aes(y = bio17), color = "lightblue") +
  labs(x = " ", y = "PREC")

### now to the second harder part, with collected data

Biodata <- read.csv("Paleodata_Blata.csv")

XRF <- ggplot(Biodata, aes(x = XRF.cal.yr.BP, y= PC1)) +
  geom_line(color = "chocolate1") +
  geom_line(aes(y=PC2), color = "orchid") +
  geom_line(aes(y=PC3), color = "lightskyblue1") +
  labs(x = " ", y = "PC score") +
  scale_x_continuous(limits = c(0, 8000))

####Pollen not working
polgroup <- rep(Biodata[15:17], each=3)
##??value <- Biodata[15] 
POL <- ggplot(Biodata, aes(x = Pollen.cal.yr.BP, y = value, fill = polgroup)) +
  geom_area(position = "stack") +
  labs(x = " ", y = "Pollen percentages") +
  scale_y_continuous(limits = c(0, 100))
                  
print(POL)

CHAR <- ggplot(Biodata, aes(x = Charcoal.cal.yr.BP, y= CHAR)) +
  geom_line(color = "black") +
  geom_line(aes(y=CHAR_BG), color = "red") +
  geom_point(aes(y=Peaks1), color = "darkred", shape = 3) +
  geom_point(aes(y=Peaks2), color = "darkgrey", shape = 1) +
  labs(x = "Cal yr BP", y = "Charcoal") +
  scale_y_continuous(limits = c(0, 2.5)) +
  scale_x_continuous(limits = c(0, 8000))

print(CHAR)

### stack all on top of each other in a grid: POL missing
library(gridExtra)
grid.arrange(MAT,PREC,XRF,CHAR, nrow=4)
