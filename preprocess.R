library(plyr)

collision.raw <- read.csv("data/2012_Vehicle_Collisions_Investigated_by_State_Police.csv")
load("data/cities.gps.RObject")

cities.gps <- cities.gps[!is.na(cities.gps$lng),]
collision.df <- collision.raw[collision.raw$CITY_NAME!="",]
cities.gps$name <- as.character(cities.gps$name)
colnames(cities.gps)[1] = "CITY_NAME"

collision.df$DAY_OF_WEEK <- trimws(collision.df$DAY_OF_WEEK)
collision.df$date <- strptime(collision.df$ACC_DATE, format="%m/%d/%Y %H:%M:%S %p")
collision.df$month <- as.numeric(format(collision.df$date, "%m"))

collision.final <- data.frame(CITY_NAME=rep(cities.gps$CITY_NAME, each=12),
#                              lng=rep(cities.gps$lng, each=12),
#                              lat=rep(cities.gps$lat, each=12),
                              month=rep(1:12, nrow(cities.gps)))

cnt <- count(collision.df, vars=c("CITY_NAME", "month"))
collision.final <- merge(collision.final, cnt, by=c("CITY_NAME", "month"), all.x=T)
colnames(collision.final)[which(colnames(collision.final)=="freq")] = "Collisions"

cnt <- count(collision.df[collision.df$INJURY=="YES",], vars=c("CITY_NAME", "month"))
collision.final <- merge(collision.final, cnt, by=c("CITY_NAME", "month"), all.x=T)
colnames(collision.final)[which(colnames(collision.final)=="freq")] = "Injury"

collision.final$Injury.Percent <- collision.final$Injury/collision.final$Collisions

cnt <- count(collision.df[collision.df$PROP_DEST=="YES",], vars=c("CITY_NAME", "month"))
collision.final <- merge(collision.final, cnt, by=c("CITY_NAME", "month"), all.x=T)
colnames(collision.final)[which(colnames(collision.final)=="freq")] = "Property.Damage"

collision.final$Property.Damage.Percent <- collision.final$Property.Damage/collision.final$Collisions

collision.final[is.na(collision.final)] = 0

# # preprocessing for months
months.string <- c("January", "February", "March", "April", "May", "June",
                   "July", "September", "October", "November", "December")

collision.final$month.string  = "January"
collision.final[collision.final$month==2, "month.string"] = "February"
collision.final[collision.final$month==3, "month.string"] = "March"
collision.final[collision.final$month==4, "month.string"] = "April"
collision.final[collision.final$month==5, "month.string"] = "May"
collision.final[collision.final$month==6, "month.string"] = "June"
collision.final[collision.final$month==7, "month.string"] = "July"
collision.final[collision.final$month==8, "month.string"] = "August"
collision.final[collision.final$month==9, "month.string"] = "September"
collision.final[collision.final$month==10, "month.string"] = "October"
collision.final[collision.final$month==11, "month.string"] = "November"
collision.final[collision.final$month==12, "month.string"] = "December"

collision.final$month.string = factor(collision.final$month.string,
                                      levels=c("January", "February", "March", "April",
                                               "May", "June", "July", "August", "September",
                                               "October", "November", "December"))


save(collision.final, file="data/collision.final.RObject")
write.csv(collision.final, file="data/collision.final.csv", row.names=F)

load("data/cities.gps.RObject")
write.csv(cities.gps, file="data/cities.gps.csv", row.names = F)
