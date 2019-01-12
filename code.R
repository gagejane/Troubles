df <-read.csv('/Users/janestout/Dropbox/Galvanize/DSI/Capstones/Capstone2_working/GTD/data/globalterrorismdb_0718dist.csv')

#Select data on Ireland and the UK
ireland <- subset(df, df$country==96 | df$country==603)

#Subset data into Troubles vs post-Troubles
ireland_after_troubles <- subset(ireland, iyear>1998)
ireland_troubles <-subset(ireland, iyear<1999)

#Plot number of attacks on subset data
library(ggplot2)
install.packages('rworldmap')
library(rworldmap)

#Troubles
newmap <- getMap(resolution='low')
png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/ireland_troubles1.png', width=600, height=400)
plot(newmap, xlim=c(-5,-2), ylim=c(48,60), asp=1)
title(main='Terrorist Attacks During The Troubles (1970-1998)')
points(ireland_troubles$longitude, ireland_troubles$latitude, col=rgb(1,0,0, alpha=.5), cex=.6, pch=20)
dev.off()

#After Troubles
newmap <- getMap(resolution='low')
png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/ireland_after_troubles1.png', width=600, height=400)
plot(newmap, xlim=c(-5,-2), ylim=c(48,60), asp=1)
title(main='Terrorist Attacks After The Troubles (1999-2017)')
points(ireland_after_troubles$longitude, ireland_after_troubles$latitude, col='blue', cex=.4, pch=20)
dev.off()

####Analysis by Ireland, Northern Ireland, Great Britain 

#natlty1: nationality of victims; use this variable bc country does not distinguish between Great Britai and Northern Ireland
#Subset data to only show data for three regions of interest
ireland_nationality <- subset(df, df$natlty1==96 | df$natlty1==216 | df$natlty1==233)
table(ireland_nationality$natlty1)

#label regions
ireland_nationality$Region <- ireland_nationality$natlty1
ireland_nationality$Region[ireland_nationality$Region==96] <- 'Ireland' 
ireland_nationality$Region[ireland_nationality$Region==216] <- 'Great Britain' 
ireland_nationality$Region[ireland_nationality$Region==233] <- 'Northern Ireland' 
table(ireland_nationality$Region)

#create subset of data that aggregates attacks for each year for each region 
year_agg <- aggregate(eventid ~ iyear + Region, data=ireland_nationality, FUN = length)
year_agg[nrow(year_agg) + 1,] = list(1993, 'Great Britain', 59)
year_agg[nrow(year_agg) + 1,] = list(1993, 'Ireland', 4)
year_agg[nrow(year_agg) + 1,] = list(1993, 'Northern Ireland', 165)
year_agg

attach(year_agg)
png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/Troubles_Time_threegroup.png', width = 1000, height = 500, units = "px")
ggplot(year_agg, aes(iyear, eventid, group=Region))+
  geom_line(aes(color=Region), size=1)+
  ggtitle('Number of Terrorist Attacks Over Time')+
  theme_bw()+
  theme(plot.title = element_text(size=14, face='bold', hjust=.5),
        axis.title = element_text(size=12, face='bold'),
        axis.text = element_text(size=12),
        axis.text.x = element_text(angle=70, hjust=1),
        legend.title = element_text(size=12, face='bold'),
        legend.text = element_text(size=12),
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+
  xlab("Year")+
  ylab('Count')+
  scale_x_continuous(breaks=iyear)
dev.off()

#create subset of data that aggregates the number of fatalities for each year for each region
kill_agg <- aggregate(nkill ~ iyear+Region, data=ireland_nationality, FUN = sum)
kill_agg[nrow(kill_agg) + 1,] = list(1993, 'Great Britain', 2)
kill_agg[nrow(kill_agg) + 1,] = list(1993, 'Ireland', 1)
kill_agg[nrow(kill_agg) + 1,] = list(1993, 'Northern Ireland', 73)
kill_agg

attach(kill_agg)
png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/Troubles_kill_threegroup.png', width = 1000, height = 500, units = "px")
ggplot(kill_agg, aes(iyear, nkill, group=Region))+
  geom_line(aes(color=Region), size=1)+
  ggtitle('Number of People Killed Over Time')+
  theme_bw()+
  theme(plot.title = element_text(size=14, face='bold', hjust=.5),
        axis.title = element_text(size=12, face='bold'),
        axis.text = element_text(size=12),
        axis.text.x = element_text(angle=70, hjust=1),
        legend.title = element_text(size=12, face='bold'),
        legend.text = element_text(size=12),
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+
  xlab("Year")+
  ylab('Count')+
  scale_x_continuous(breaks=iyear)
dev.off()

#ATTACK TYPE BY REGION
ireland_nationality$Troubles <- ifelse(ireland_nationality$iyear <1999, 'During', 'Post-Troubles')
ireland_after_troubles <- subset(ireland_nationality, iyear>1998)
ireland_troubles <-subset(ireland_nationality, iyear<1999)

ireland_after_troubles$Region <- ireland_after_troubles$natlty1
ireland_after_troubles$Region[ireland_after_troubles$Region==96] <- 'Ireland' 
ireland_after_troubles$Region[ireland_after_troubles$Region==216] <- 'Great Britain' 
ireland_after_troubles$Region[ireland_after_troubles$Region==233] <- 'Northern Ireland' 

table(ireland_after_troubles$Region)

ireland_troubles$Region <- ireland_troubles$natlty1
ireland_troubles$Region[ireland_troubles$Region==96] <- 'Ireland' 
ireland_troubles$Region[ireland_troubles$Region==216] <- 'Great Britain' 
ireland_troubles$Region[ireland_troubles$Region==233] <- 'Northern Ireland' 
table(ireland_troubles$Region)

ireland_nationality$attacktype1 <- as.factor(ireland_nationality$attacktype1)
ireland_troubles$attacktype1 <- as.factor(ireland_troubles$attacktype1)
ireland_after_troubles$attacktype1 <- as.factor(ireland_after_troubles$attacktype1)

levels(ireland_nationality$attacktype1)
levels(ireland_troubles$attacktype1)
levels(ireland_after_troubles$attacktype1)

#relabel number codes into actual words
levels(ireland_nationality$attacktype1) <- c('1'="Assassination", '2'='Armed Assault', '3'='Bombing or Explosion', '4'='Hijacking', '5'='Hostage Taking: Barricade', '6'='Hostage Taking: Kidnapping', '7'='Facility or Infrastructure', '8'='Unarmed Assault', 
                                 '9'='Other')
levels(ireland_troubles$attacktype1) <- c('1'="Assassination", '2'='Armed Assault', '3'='Bombing or Explosion', '4'='Hijacking', '5'='Hostage Taking: Barricade', '6'='Hostage Taking: Kidnapping', '7'='Facility or Infrastructure', '8'='Unarmed Assault', 
                                          '9'='Other')
levels(ireland_after_troubles$attacktype1) <- c('1'="Assassination", '2'='Armed Assault', '3'='Bombing or Explosion', '4'='Hijacking', '5'='Hostage Taking: Barricade', '6'='Hostage Taking: Kidnapping', '7'='Facility or Infrastructure', '8'='Unarmed Assault', 
                                                '9'='Other')
#wrap long labels
ireland_nationality$attacktype1 <- sapply(ireland_nationality$attacktype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_troubles$attacktype1 <- sapply(ireland_troubles$attacktype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_after_troubles$attacktype1 <- sapply(ireland_after_troubles$attacktype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)


counts <- prop.table(table(ireland_nationality$Troubles, ireland_nationality$attacktype1),1)
counts_troubles <- prop.table(table(ireland_troubles$Region, ireland_troubles$attacktype1),1)
na.omit(counts_troubles)
counts_after_troubles <- prop.table(table(ireland_after_troubles$Region, ireland_after_troubles$attacktype1),1)

counts
counts_troubles
counts_after_troubles

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/AttackType1.png', width=18, height=9)
barplot(counts, main='Attack Type During and After the Troubles', xlab = 'Attack Type', ylab='Proportion', col=c('red', 'blue'), 
        legend=rownames(counts), beside=TRUE, ylim=c(0,1))
dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/AttackType_troubles_threegroup3.png', width = 1000, height = 500, units = "px")
barplot(counts_troubles, main='Attack Type During The Troubles', xlab = 'Attack Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_troubles), beside=TRUE, ylim=c(0,1), cex.names = .8)
dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/AttackType_after_troubles_threegroup3.png', width = 1000, height = 500, units = "px")
barplot(counts_after_troubles, main='Attack Type After The Troubles', xlab = 'Attack Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_after_troubles), beside=TRUE, ylim=c(0,1), cex.names = .8)
dev.off()

#WEAPON TYPE BY REGION
ireland_nationality$weaptype1 <- as.factor(ireland_nationality$weaptype1)
ireland_troubles$weaptype1 <- as.factor(ireland_troubles$weaptype1)
ireland_after_troubles$weaptype1 <- as.factor(ireland_after_troubles$weaptype1)

levels(ireland_nationality$weaptype1)
levels(ireland_troubles$weaptype1)
levels(ireland_after_troubles$weaptype1)

#levels(ireland_nationality$weaptype1) <- c('1'='Biological', '2'='Chemical', '5'='Firearms', '6'='Explosives', '8'='Incendiary', '9'='Melee', '10'='Vehicle','11'='Sabotage Equipment', '12'='Other', '13'='Unknown')
#levels(ireland_troubles$weaptype1) <- c('1'='Biological', '2'='Chemical', '5'='Firearms', '6'='Explosives', '8'='Incendiary', '9'='Melee', '10'='Vehicle', '12'='Other', '13'='Unknown')
#levels(ireland_after_troubles$weaptype1) <- c('2'='Chemical', '5'='Firearms', '6'='Explosives', '8'='Incendiary', '9'='Melee', '10'='Vehicle','11'='Sabotage Equipment', '12'='Other', '13'='Unknown')
# 
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='1'] <- 'Other'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='2'] <- 'Other'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='5'] <- 'Firearms'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='6'] <- 'Explosives'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='8'] <- 'Incendiary'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='9'] <- 'Melee'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='10'] <- 'Vehicle'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='12'] <- 'Other'
# ireland_troubles$weaptype1[ireland_troubles$weaptype1 =='13'] <- 'Other'
# table(ireland_troubles$weaptype1)

levels(ireland_troubles$weaptype1) <- c('1'='Other', '2'='Other', '5'='Firearms', '6'='Explosives', '8'='Incendiary', '9'='Melee', '10'='Other', '12'='Other', '13'='Other')
levels(ireland_after_troubles$weaptype1) <- c('2'='Other', '5'='Firearms', '6'='Explosives', '8'='Incendiary', '9'='Melee', '10'='Other','11'='Other', '12'='Other', '13'='Other')


#wrap long labels
#ireland_nationality$weaptype1 <- sapply(ireland_nationality$weaptype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_troubles$weaptype1 <- sapply(ireland_troubles$weaptype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_after_troubles$weaptype1 <- sapply(ireland_after_troubles$weaptype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)

#counts <- prop.table(table(ireland_nationality$Troubles, ireland_nationality$weaptype1),1)
counts_troubles <- prop.table(table(ireland_troubles$Region, ireland_troubles$weaptype1),1)
counts_after_troubles <- prop.table(table(ireland_after_troubles$Region, ireland_after_troubles$weaptype1),1)

#counts
counts_troubles
counts_after_troubles

#png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/WeapType.png', width=15, height=9)
#barplot(counts, main='Weapon Type During and After the Troubles', xlab = 'Weapon Type', ylab='Proportion', col=c('red', 'blue'), 
#        legend=rownames(counts), beside=TRUE, ylim=c(0,1))
#dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/WeapType_troubles_threegroup.png', width = 1000, height = 500, units = "px")
barplot(counts_troubles, main='Weapon Type during the Troubles', xlab = 'Weapon Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_troubles), beside=TRUE, ylim=c(0,1))
dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/WeapType_after_troubles_threegroup.png', width = 1000, height = 500, units = "px")
barplot(counts_after_troubles, main='Weapon Type After the Troubles', xlab = 'Weapon Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_after_troubles), beside=TRUE, ylim=c(0,1))
dev.off()

#VICTIM/TARGET TYPE
#ireland_nationality$targtype1 <- as.factor(ireland_nationality$targtype1)
ireland_troubles$targtype1 <- as.factor(ireland_troubles$targtype1)
ireland_after_troubles$targtype1 <- as.factor(ireland_after_troubles$targtype1)

#levels(ireland_nationality$targtype1)
levels(ireland_troubles$targtype1)
levels(ireland_after_troubles$targtype1)

#levels(ireland_nationality$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '5'='Abortion Related', '6'='Airports/Aircraft', '7'='Government (Diplomatic)', '8'='Educational Institution', '9'='Food/Water Supply', '10'='Journalists/Media','11'='Maritime', '12'='NGO', '13'='Other', '14'='Private Citizens/Property', '15'='Religious Figures/Insts', '16'='Telecommunications', '17'='Terrorists', '18'='Tourists', '19'='Transportation', '20'='Unknown', '21'='Utilites', '22'='Violent Political Parties')
#levels(ireland_troubles$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '5'='Abortion Related', '6'='Airports/Aircraft', '7'='Government (Diplomatic)', '8'='Educational Institution', '9'='Food/Water Supply', '10'='Journalists/Media','11'='Maritime', '12'='NGO', '14'='Private Citizens/Property', '15'='Religious Figures/Insts', '16'='Telecommunications', '17'='Terrorists', '18'='Tourists', '19'='Transportation', '20'='Unknown', '21'='Utilites', '22'='Violent Political Parties')
#levels(ireland_after_troubles$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '6'='Airports/Aircraft', '7'='Government (Diplomatic)', '8'='Educational Institution', '10'='Journalists/Media', '12'='NGO', '13'='Other', '14'='Private Citizens/Property', '15'='Religious Figures/Insts', '16'='Telecommunications', '17'='Terrorists', '18'='Tourists', '19'='Transportation', '20'='Unknown', '21'='Utilites', '22'='Violent Political Parties')

#levels(ireland_nationality$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '5'='Other', '6'='Other', '7'='Government', '8'='Other', '9'='Other', '10'='Other','11'='Other', '12'='Other', '13'='Other', '14'='Private Citizens/Property', '15'='Religious Figures or Institutions', '16'='Other', '17'='Terrorists or Non-State Actors', '18'='Other', '19'='Other', '20'='Other', '21'='Other', '22'='Other')
levels(ireland_troubles$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '5'='Other', '6'='Other', '7'='Government', '8'='Other', '9'='Other', '10'='Other','11'='Other', '12'='Other', '14'='Private Citizens/Property', '15'='Religious Figures or Institutions', '16'='Other', '17'='Terrorists or Non-State Actors', '18'='Other', '19'='Other', '20'='Other', '21'='Other', '22'='Other')
levels(ireland_after_troubles$targtype1) <- c('1'='Business', '2'='Government', '3' = 'Police', '4'='Military', '6'='Other', '7'='Government', '8'='Other', '10'='Other', '12'='Other', '13'='Other', '14'='Private Citizens/Property', '15'='Religious Figures or Institutions', '16'='Other', '17'='Terrorists or Non-State Actors', '18'='Other', '19'='Other', '20'='Other', '21'='Other', '22'='Other')


#wrap long labels
#ireland_nationality$targtype1 <- sapply(ireland_nationality$targtype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_troubles$targtype1 <- sapply(ireland_troubles$targtype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)
ireland_after_troubles$targtype1 <- sapply(ireland_after_troubles$targtype1, function(x) paste(strwrap(x,20), collapse = "\n"), USE.NAMES = FALSE)

#counts <- prop.table(table(ireland_nationality$Troubles, ireland_nationality$targtype1),1)
counts_troubles <- prop.table(table(ireland_troubles$Region, ireland_troubles$targtype1),1)
counts_after_troubles <- prop.table(table(ireland_after_troubles$Region, ireland_after_troubles$targtype1),1)

#counts
counts_troubles
counts_after_troubles

#png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/Target.png', width=12, height=9)
#barplot(counts, main='Target Type During and After the Troubles', xlab = 'Target Type', ylab='Proportion', col=c('red', 'blue'), 
#        legend=rownames(counts), beside=TRUE, ylim=c(0,1),cex.names=1)
#dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/Target_troubles_threegroup3.png', width = 1000, height = 500, units = "px")
barplot(counts_troubles, main='Target Type During The Troubles', xlab = 'Target Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_troubles), beside=TRUE, ylim=c(0,1), cex.names = .8)
dev.off()

png('/Users/janestout/Dropbox/Projects/Ireland/Troubles/images/Target_after_troubles_threegroup3.png', width = 1000, height = 500, units = "px")
barplot(counts_after_troubles, main='Target Type After The Troubles', xlab = 'Target Type', ylab='Proportion', col=c('red', 'green', 'blue'), 
        legend=rownames(counts_after_troubles), beside=TRUE, ylim=c(0,1), cex.names=.8)
dev.off()


#Recent events: 2017 data
#Make Table
ireland_2017 <- subset(ireland_nationality, iyear==2017)
ireland_2017$gname

group_agg <- aggregate(eventid ~ gname + Region, data=ireland_2017, FUN = length)
group_agg <- group_agg[with(group_agg, order(Region, -eventid)),]
group_agg$Count <- group_agg$eventid
group_agg$Organization <- group_agg$gname
drops <- c('eventid', 'gname')
group_agg <- group_agg[, !(names(group_agg) %in% drops)]
write.csv(group_agg, file = "/Users/janestout/Dropbox/Projects/Ireland/Troubles/group_agg.csv", row.names=F)
group_agg

###Claimed responsibilty by region
ireland_2017$claimed_str <- ireland_2017$claimed
ireland_2017$claimed_str[ireland_2017$claimed_str==1] <- 'Claimed Responsibility' 
ireland_2017$claimed_str[ireland_2017$claimed_str==0] <- 'Did not claim' 

table(ireland_2017$claimed_str)
ireland_2017$claimed_str[ireland_2017$claimed_str ==-9] <- NA
counts <- table(ireland_2017$Region, ireland_2017$claimed_str)
counts_prop <- prop.table(table(ireland_2017$Region, ireland_2017$claimed_str),1)
counts
counts_prop

#groups that claimed responsibilty 
ireland_2017_claimed <- subset(ireland_2017, claimed==1)
claimed_agg <- aggregate(claimed ~ gname, data=ireland_2017_claimed, FUN = length)
claimed_agg

###Property damage by region
ireland_2017$property_str <- ireland_2017$property
ireland_2017$property_str[ireland_2017$property_str==1] <- 'Property Damage' 
ireland_2017$property_str[ireland_2017$property_str==0] <- 'No Damage' 

table(ireland_2017$property_str)
ireland_2017$property_str[ireland_2017$property_str ==-9] <- NA
counts <- table(ireland_2017$Region, ireland_2017$property_str)
counts_prop <- prop.table(table(ireland_2017$Region, ireland_2017$property_str),1)
counts
counts_prop
