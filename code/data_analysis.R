#loading packages
#reading in data

library(tidyverse)

sample_data <-  read_csv("data/sample_data.csv")

summarize(sample_data, averageo_cells = mean(cells_per_ml))

#this is called a pipe operator, it is different from the R base pipe operator that is pre-loaded
#it takes what is on the left, and pipes it into what is on the right
#can keep it clean by adding a new line to indicate the other side of the pipe (which is what the left side is being piped through)

sample_data %>% 
  summarize(average_cells = mean(cells_per_ml))

#filtering rows
#in tidyverse, when you are referencing a columnn name, you do not need to add quotations marks
#double equal sign is a logical operator, asking at each row if it is equal to deep, double equal actually means "is equal to"
#exclamation plus equal sign means "not equal to" !=

sample_data %>%
  filter(env_group == "Deep") %>%
  summarize(average_cells = mean(cells_per_ml))

sample_data %>%
  filter(depth <= 50) %>%
  summarize(average_cells = mean(cells_per_ml))

sample_data %>%
  filter(env_group %in% c("Deep", "Shallow_May")) %>%
  summarize(average_cells = mean(cells_per_ml))

#example of string R function using a wild card
sample_data %>%
  filter(str_detect(env_group, "Shallow*"))

#calculate the average chlorophyll in the entire dataset
sample_data %>%
  summarize(average_chlorophyll = mean(chlorophyll))


#then calculate the average chlorophyll in Shallow September only
sample_data %>%
  filter(env_group == "Shallow_September") %>%
  summarize(Shallow_September_chlorophyll = mean(chlorophyll))

#deprecated means that a package had a function and the program is encouraging you to use a different function, becuase in the future, that function will not be used

# group_by
sample_data %>%
  group_by(env_group) %>%
  summarize(average_cells = mean(cells_per_ml),
            min_cells = min(cells_per_ml))

#calculate the average temp per env_group
sample_data %>%
  group_by(env_group) %>%
  summarize(average_temperature = mean(temperature))

#how to make new columns in our dataframe using the function Mutate
# TN:TP ratio calculation
# can pipe into a view command, that's pretty cool
sample_data %>%
  mutate(tn_tp_ratio = total_nitrogen/total_phosphorus) %>% view

sample_data %>%
  mutate(temp_is_hot = temperature > 8) %>% view

sample_data %>%
  mutate(temp_is_hot = temperature > 8) %>%
  group_by(env_group, temp_is_hot) %>%
  summarize(avg_temp = mean(temperature),
            avg_cells = mean(cells_per_ml)) %>%
  view

#selecting columns with the select function
sample_data %>%
  select(sample_id, depth)

sample_data %>%
  select(-env_group)

#using a colon tells R to select a range of values
sample_data %>%
  select(sample_id:temperature)

#select has a bunch of helper functions, such as "starts with" or "ends with"
sample_data %>%
  select(starts_with("total"))


#create a data frame iwth only sample_id, depth, temperature, and cells_per_mil
sample_data %>%
  select(sample_id, env_group, depth, temperature, cells_per_ml) %>%
  view

#now, find another way to do this same thing
sample_data %>%
  select(-total_nitrogen, -total_phosphorus, -diss_org_carbon, -chlorophyll)

#and another
sample_data %>%
  select(sample_id:temperature)

#he says there is a fourth way
sample_data %>%
  select(-(total_nitrogen:chlorophyll))

#another one to try
sample_data %>%
  select(1:5)

#another one to try
sample_data %>%
  select(-(6:9))


#CLEANING DATA
#can hit tab for autocomplete for R
read_csv("data/taxon_abundance.csv", skip = 2) %>%
  select(-...10) %>%
  rename(sequencer = ...9) %>%
  view

#CHALLENGE: removing the sequencer and lot number columns and then assign the new data frame to the object named "taxon_cleaner"
taxon_clean <- read_csv("data/taxon_abundance.csv", skip = 2) %>%
  select(-(Lot_Number:...10))

#doing it the way he showed it instead, he justified adding the column name before removing so that any subsequent person (or his future self) would know why he did this
taxon_clean <-  read_csv("data/taxon_abundance.csv", skip = 2) %>%
  select(-...10) %>%
  rename(sequencer = ...9) %>%
  select(-Lot_Number, -sequencer)


#talkin' 'bout long data versus wide data frames, we are selecting all bacterial phylum columns and compressing them into long data by making those into items in a "Phylum" column
#went up to 400+ rows instead of what we had before
#one clue about wide format versus long format is whether or not multiple columns have the same units, are they measuring different things and are different from each other?
#you are kind of compressing the data into a different format, showing the same things, but making it into long format data so you can use more functions in the tidyverse

taxon_long <- taxon_clean %>%
  pivot_longer(cols = Proteobacteria:Cyanobacteria,
               names_to = "Phylum",
               values_to = "Abundance")

#pivoting to a long dataframe makes it easier to summarize
#looking at the average relative abundance of each phylyum across all samples together
taxon_long %>%
  group_by(Phylum) %>%
  summarize(avg_abund = mean(Abundance))

#very common plot, a stacked bar plot
#we could not have done this with our wide dataframe
taxon_long %>%
  ggplot() +
  aes(x = sample_id,
      y = Abundance,
      fill = Phylum) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90))

# Making long data wide
#some ecology packages may require wide data formats
taxon_long %>%
  pivot_wider(names_from = "Phylum",
              values_from = "Abundance") %>%
  view

# joining dataframes, taking dataframes that have some matching key value
head(sample_data)

head(taxon_clean)

#these dataframes are matched by the column "sample_id"
#inner join is when you combine based on the matches of one column, and any entries that are not found in both dataframes are dropped
#a full join is when you keep all of the key pairs, but also you keep any entries that do not match
#directional join is when you decide if you are going to drop any entries that do not match from one of the tables (i.e., keep entries from 1 that are not found in 2, drop entries in 2 that are not found in 1)
#an anti-join is when you only keep key pairs that are not present in both (or it can be directional in some languages)
#inner join, full join, directional join, anti-join

inner_join(sample_data, taxon_clean, by = "sample_id") %>%
  view

anti_join(sample_data, taxon_clean, by = "sample_id") %>%
  view

#print out sample ids for sample data set
sample_data$sample_id

#pring out sample ids for taxon clean
taxon_clean$sample_id

#we need to mutate the names in the taxon_clean dataframe to match those inthe sample_data dataframe
taxon_clean_goodSep <- taxon_clean %>%
  mutate(sample_id = str_replace(sample_id, pattern = "Sep", replacement = "September"))

inner_join(sample_data, taxon_clean_goodSep, by = "sample_id")

#if you want, you can join by multiple columns simultaneously
#if you need to append rows onto the end, you will be using a bind function

sample_and_taxon <- inner_join(sample_data, taxon_clean_goodSep, by = "sample_id")

write_csv(sample_and_taxon,file = "data/sample_and_taxon.csv")

#make a plot
#ask: Where does Chloroflexi like to live?

sample_and_taxon %>%
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth()

#y~x as part of the output means "y as a function of x", geom_smooth uses a default loess model

sample_and_taxon %>%
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth()

#now we are specifying the method to be linear model
sample_and_taxon %>%
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth(method = lm)

#can add an equation line
#install.packages("ggpubr")
library(ggpubr)

sample_and_taxon %>%
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth(method = lm) +
  stat_regline_equation()

#or add correlation?
sample_and_taxon %>%
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs(x = "Depth (m)",
       y = "Chloroflexi relative abundance") +
  geom_smooth(method = lm) +
  stat_cor()

#What is the average abundance and standard deviation of Chloroflexi in our 3 env_groups?
sample_and_taxon %>%
  group_by(env_group) %>%
  summarize(avg_abund_chloro = mean(Chloroflexi)) 
  
#now for the standard deviation
sample_and_taxon %>%
  group_by(env_group) %>%
  summarize(avg_abund_chloro = sd(Chloroflexi)) 

#now to combine into one function
sample_and_taxon %>%
  group_by(env_group) %>%
  summarize(avg_chloro = mean(Chloroflexi),
            sd_chloro = sd(Chloroflexi))


