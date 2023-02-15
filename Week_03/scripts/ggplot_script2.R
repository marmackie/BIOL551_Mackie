##### 
#
library(palmerpenguins)
library(tidyverse)
library(here)
library(devtools)
library(beyonce)

glimpse(penguins)

plot1 <- ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     group = species,
                     color = species))+
  geom_point()+
    geom_smooth(method = "lm")+
    labs(x = "Bill depth (mm)",
         y = "Bill length (mm)"
         )
   # scale_color_viridis_d()+
   # scale_x_continuous(limits = c(0,20))+
   # scale_y_continuous(limits = c(0,50))+
  # scale_x_continuous(breaks = c(14,17,21),
                     # labels = c("low", "medium","high"))+
  #  scale_color_manual(values = c("orange", "purple", "green"))+
  # for bar and other plot that use fill, use scale_fill_manual
   # scale_color_manual(values = beyonce_palette(2))+
   # coord_fixed()
    
   # ggplot(diamonds, aes(carat, price)) + 
   #   geom_point()
   #   coord_trans(x = "log10", y ="log10")
   #   coord_polar("x")
    
   # theme_classic()
  #  theme_bw()
   # theme(axis.title = element_text(size = 20,
   #                                 color = "red"))
   # panel.background = element_rect(fill = "linen")
plot1
ggsave(here("Week_03","output","ggplot_penguin.png"),
      width = 7, height = 5)