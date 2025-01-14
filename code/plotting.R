2+2

library(tidyverse)

#read.csv is base R, read_csv is tidyverse; that little arrow is called the assignment operator, can do option + - to make it!
sample_data <- read_csv("sample_data.csv")

#a tibble (table?)is a specialized dataframe; a data table is different?

#assign values to objects
name <- "agar"
name

year <- 1881
year

name <- "Fanny Hesse"
name

#bad names for object (do not start an object name with a number)
1number <- 3

#better name
number1 <- "3"

Flower <- "marigold"
Flower

flower <- "rose"
flower

sample_data <- read_csv("sample_data.csv")

#must provide the file name, otherwise it becomes confused
read_csv()

#R does not care about single quotation marks or double quotation marks
#in this line of code, "file" is the argument name
read_csv(file = 'sample_data.csv')

# let's comment
Sys.Date() # outputs the current date

getwd() #outputs the current working directory

sum(5,6) #adds numbers

read_csv(file = "sample_data.csv") # reads in csv file




# creating first plot
ggplot(data = sample_data)

#aes is aesthetic, and is hwere you put in what the plot will look like; this is temperature only
ggplot(data = sample_data) +
  aes(x = temperature)

#let's add a label to that little baby; if you want to use column names as the label, then it will automatically do that for you,
#to name it yourself, add a label and put that name in quotes as such
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)")

#now we will add the y-axis
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml) +
  labs(y = "Cells per mL")

#now adding some data points and a title
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml) +
  labs(y = "Cells per mL") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?")


#now adding color to the plot
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml) +
  labs(y = "Cells per mL") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?") +
  aes(color = env_group)


#now adding a chlorophyll layer to group size of points according to size of chlorophyll
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml) +
  labs(y = "Cells per mL") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?") +
  aes(color = env_group) +
  aes(size = chlorophyll)


#now adding more labels
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml) +
  labs(y = "Cells per mL") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?") +
  aes(color = env_group) +
  aes(size = chlorophyll) +
  labs(size = "Chlorophyll (ug/L)",
       color = "Environmental Group")


#changing the labeling to be better
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml/1000000) +
  labs(y = "Cells (millions/mL)") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?") +
  aes(color = env_group) +
  aes(size = chlorophyll) +
  labs(size = "Chlorophyll (ug/L)",
       color = "Environmental Group")

#changing shapes in our data
ggplot(data = sample_data) +
  aes(x = temperature) +
  labs(x = "Temperature (C)") +
  aes(y = cells_per_ml/1000000) +
  labs(y = "Cells (millions/mL)") +
  geom_point() +
  labs(title = "Does temperature affect microbial abundance?") +
  aes(color = env_group) +
  aes(size = chlorophyll) +
  aes(shape = env_group) +
  labs(size = "Chlorophyll (ug/L)",
       color = "Environmental Group",
       shape = "Environmental Group")

#combined "neater" code
ggplot(data = sample_data) +
  aes(x = temperature,
      y = cells_per_ml/1000000,
      color = env_group,
      size = chlorophyll) +
  geom_point() +
  labs(x = "Temperature (C)",
       y = "Cells (millions/mL)",
       title = "Does temperature affect microbial abundance?",
       size = "Chlorophyll (ug/L)",
       color = "Environmental Group")


#importing datasets, we are getting temp data sets from buoys from different orgs
#can use the view command to open your dataset
buoy_data <- read_csv("buoy_data.csv")
View(buoy_data)

dim(buoy_data)

#quick peek at the beginning of the dataset
head(buoy_data)

#quick peek at the last few entries of the dataset
tail(buoy_data)

#our data is loaded, let's get into plotting
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      color = depth) + 
  geom_point()

#with this, it is hard to differentiate which data point is connected to which, or what this plot means, let's add more information

#let's look at the structure of our data object
str(buoy_data)

#plot with more info
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = buoy) + 
  geom_line()


#let us introduce facets, to add a facet you have to use a tilda so R knows what you want
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = depth) + 
  geom_line() +
  facet_wrap(~buoy)
  
#changing the axes for the facets? this seems pandemonious, why would you do that?
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = depth) + 
  geom_line() +
  facet_wrap(~buoy, scales = "free_y")

#messing with facets some more, doing a facet grid, vars is referencing the column "buoy", using group is helpful because it shows up which points are connected (aka, the datapoints are grouped by buoys)
#vars is emphasizing what we are faceting by
ggplot(data = buoy_data) +
  aes(x = day_of_year,
      y = temperature,
      group = sensor,
      color = depth) + 
  geom_line() +
  facet_grid(rows = vars(buoy))


#discrete plots, add jitter to make it so your points don't overlap? and are shown?
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  geom_jitter()


#make boxplot first, then jitter second, so your points are not hidden by the boxplot
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_jitter() +
  geom_boxplot()


#add some aesthetic
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  geom_jitter(aes(size = chlorophyll))

#adding osme colors and the such, rememberf there is a difference between color and fill
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(color = "pink")

#let's do fill instead
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "wheat")

#to get palette suggestions, you can go into console and type > sample(colors(), size = 10) and it will make you a palette
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = c("pink", "tomato", "papayawhip"))

#let's do scale fill brewer using R's pre-installed palettes
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_brewer(palette = "Set1")

#to look at palettes, go into Console and enter > RColorBrewer::display.brewer.all()

#instead of scale fill Brewer, let's download a custom palette and use it
#install.packages("wesanderson")
#install.packages("harrypotter")
library(wesanderson)
library(harrypotter)

ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = wes_palette(("Cavalcanti1")))

ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_hp(discrete = TRUE, house = "slytherin")

#install.packages("ggsci")
library(ggsci)

ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_color_rickandmorty("schwifty")

#boxplot
#change transparency
#use outliers = FALSE to take out those outliers
ggplot(data = sample_data) + 
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "darkblue",
               outliers = FALSE,
               alpha = 0.3)

#univariate plots
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_density()

#let's add some fill and more information, plus some transparency 
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_density(aes(fill = env_group), alpha = 0.5)

#let's take out that grey background
ggplot(sample_data) +
  aes(x = cells_per_ml) +
  geom_density(aes(fill = env_group), alpha = 0.5) +
  theme_minimal()

#let's make a plain boxplot, then figure out how to rotate the x-axis
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  theme_classic()

#x-axis rotated
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

#saving plots
#can also use export tab and save as an image
ggsave("awesome_plot.jpeg", width = 6, height = 4, dpi = 500)

#storing plots as a variable
box_plot <- 
  ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

box_plot <- box_plot + theme_bw()
box_plot
box_plot

ggsave("awesome_box_plot_example.jpg", plot = box_plot, width = 6, height = 4)


