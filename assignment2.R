rm(list = ls())
#dev.off()
# ctrl + n + l puhdistaa console ikkunan
# ctrl + enter => run

#install.packages("markovchain", dependencies=TRUE)
#install.packages("matlab")
#install.packages("Rcpp")
#install.packages("wesanderson")
#install.packages("reshape2")
#install.packages("ChannelAttribution")

library(dplyr)
library(igraph)
library(igraphdata)
library(ggplot2)
library(tidyr)
library(wesanderson)
library(reshape2)
library(ChannelAttribution)
library(markovchain)

# first let's import our attribution data
df_path <- data.frame(read.csv('Attribution_assign_path.csv', header = TRUE,
                               sep = ';', stringsAsFactors = FALSE))

# CONVERSIONS AND SALES 
df_conv <- data.frame(read.csv('Attribution_assign_conv.csv', header = TRUE,
                               sep = ';', stringsAsFactors = FALSE))

head(df_path)
str(df_path)

head(df_conv)
str(df_conv)

#Let's prepare our data by converting it into an appropriate format
df_path = df_path %>% 
  arrange(client_id, date) %>%
  group_by(client_id) %>%
  summarise(path = paste(channel, collapse = '>')) %>%
  ungroup()


str(df_path)
df_path[1,]

# Let's merge our path and conversions data
df_attrib <- merge(df_path, df_conv, by = 'client_id')
str(df_attrib)





# Let's make our first attribution model
Hmdl = heuristic_models(df_attrib, var_path = 'path', var_conv = 'conv', var_value = 'conv_val')

Hmdl

# Let's make our Markov Chain model
Mmdl = markov_model(df_attrib, var_path = 'path', var_conv = 'conv', var_value = 'conv_val', order = 1, out_more = TRUE)

Mmdl 








#Let's merge our results and compare them
Results1 = merge(Hmdl, Mmdl$result, by = 'channel_name')

head(Results1)
#class(Hmdl)
#class(Mmdl)


#Let's prepare for making a barplot
str(Results1)
vars_to_keep_c = c('channel_name','first_touch_conversions','last_touch_conversions','linear_touch_conversions','total_conversions')

vars_to_keep_v = c('channel_name','first_touch_value','last_touch_value','linear_touch_value','total_conversion_value')

Results1_conv = Results1[vars_to_keep_c]
Results1_val = Results1[vars_to_keep_v]

#Let's make the conversion plot
Conversions = melt(Results1_conv, id='channel_name')
str(Conversions)

po_conv = ggplot(Conversions, aes(x=channel_name, y = value, fill = variable))+
  geom_bar(stat = 'identity', position = 'dodge')+
  ggtitle('Attributed Conversions')+
  labs(x='Channel Names', y='Conversions')+
  theme(legend.position = 'bottom')+
  scale_fill_discrete(name='Attribution model',labels = c('First touch', 'Last touch', 'Linear touch', '1st order Markov'))

po_conv



Value = melt(Results1_val, id = 'channel_name')

po_val = ggplot(Value, aes(x=channel_name, y = value, fill = variable))+
  geom_bar(stat = 'identity', position = 'dodge')+
  ggtitle('Attributed Value')+
  labs(x='Channel Names', y='Value in Eur')+
  theme(legend.position = 'bottom')+
  scale_fill_discrete(name='Attribution model',labels = c('First touch', 'Last touch', 'Linear touch', '1st order Markov'))

po_val


######################## Let's work with the survey data

survey <- data.frame(read.csv('Survey_attribution.csv', header = TRUE, sep=';', stringsAsFactors = FALSE))
str(survey)

#Q3_0_GROUP: Need
#Q18_0_GROUP: Search
#Q19_0_GROUP: Choice

survey$Need = gsub(',',' > ',survey$Q3_0_GROUP)
survey$Search = gsub(',',' > ',survey$Q18_0_GROUP)
survey$Choice = gsub(',',' > ',survey$Q19_0_GROUP)

# Full conversion path
survey$path = do.call(paste, c(survey[,c('Need', 'Search', 'Choice')], sep =' > '))

survey$path[1] # issue with ('> >')
survey$path = gsub('>  >',' > ', survey$path)
survey$path[1]

#Let's add value and conversions information
survey$value = survey$Q14_1

survey$convert = rep(1,dim(survey)[1])

#Let's only keep relevant information for attribution modelling
df_attrib = survey[c('Need','Search','Choice','path','value','convert')]
str(df_attrib)


# Let's make our first attribution model
Hmdl = heuristic_models(df_attrib, var_path = 'path', var_conv = 'convert',
                        var_value = 'value')

Hmdl

# Let's make our Markov Chain model
Mmdl = markov_model(df_attrib, var_path = 'path', var_conv = 'convert', 
                    var_value = 'value', order = 1, out_more = TRUE)

Mmdl 

#Let's analyze the transition matrix
plot_transition = Mmdl$transition_matrix
str(plot_transition)

levels = as.character(Mmdl$result$channel_name)
plot_transition[1,]


plot_transition$channel_from[plot_transition$channel_from=='1']=levels[1]
plot_transition                        

for (i in 1:13){
  plot_transition$channel_from[plot_transition$channel_from==i]=levels[i]
  plot_transition$channel_to[plot_transition$channel_to==i]=levels[i]
  
}

plot_transition[1,]

# Let's make the heatmap of the transition probabilities
cols = wes_palette('Zissou1', 100, type='continuous')


po_heat = ggplot(plot_transition, aes(x=channel_from, y=channel_to, fill = transition_probability)) +
  geom_tile()+
  labs(x='Channel To', y='Channel From', fill = 'Transition Probability')+
  ggtitle('Transition Heatmap')+
  geom_text(aes(label=round(transition_probability,2)))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  scale_fill_gradientn(colours = cols)


