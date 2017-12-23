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

save(collision.final, file="data/collision.final.RObject")
