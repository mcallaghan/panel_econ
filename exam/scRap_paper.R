d <- data.frame(
  x = c(19,20,21,20,34,35,36,39,14,15,17,17,22,29,18,19),
  y = c(5,2,3,2,8,8,9,10,-1,0,4,3,4,1,2,3)
)

r1 <- lm(d$y ~ d$x)
summary(r1)

library(xlsx)
library(dplyr)

data <- read.xlsx("~/Documents/hertie/econometrics/panel_econ/exam/excel/CA_FX_DATA_STUD.xlsx", sheetIndex = 1) 

data <- data %>%
  filter(ind==1)

countries <- data %>%
  filter(ind==1) %>%
  group_by(country) %>%
  summarise(
    r_change = var(regime)
  )

mean(countries$r_change)

r_change <- var(data$regime)

