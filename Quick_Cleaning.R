# Get File
z <- read.csv("/Users/craigzimber/Documents/R/RMLS/RMLS 141-152 Last 9 Month 140901.csv", 
              header=TRUE, sep = ",", 
              # na.strings = "", 
              stringsAsFactors = TRUE)            

# Removes rows that dont start with a MLS#
mls <- subset(z,z$Status == "ACT" | z$Status == "BMP" | z$Status == "CAN" | 
                      z$Status == "EXP" | z$Status == "PEN" | z$Status == "SLD" | 
                      z$Status == "SNL" | z$Status == "SSP" | z$Status == "WTH")
dim(mls)

miss <- subset(z,z$Status != "ACT" & z$Status != "BMP" & z$Status != "CAN" & 
                       z$Status != "EXP" & z$Status != "PEN" & z$Status != "SLD" & 
                       z$Status != "SNL" & z$Status != "SSP" & z$Status != "WTH")
dim(miss)
#
# Split out Zip Plus 4
require(stringr)
mls$Zip.Code <- str_sub(mls$Zip.Code, start= 1, 5)

# Split out Price Range
z <- mls[,c(1,4)]
z1 <- do.call(rbind.data.frame, strsplit(as.character(z$List.Price), "-"))
colnames(z1)[1] <- "List"
colnames(z1)[2] <- "Max"
z <- cbind(z,z1)
ListPrice <- as.numeric(levels(z$List[])[z$List[]])
MaxPrice <- as.numeric(levels(z$Max[])[z$Max[]])
z <- cbind(z,ListPrice,MaxPrice)

j<-nrow(z) 
for (i in 1:j ) {   
        if(z[i,5] == z[i,6])
        {z[i,7] <- NA
        } else {
                z[i,7] <- z[i,6]
        }
        }
z <- z[,-c(2,3,4,6)]                

colnames(z)[2] <- "List.Price"
colnames(z)[3] <- "Max.Price"
mls <- cbind(z,mls)
mls <-mls[,-c(4, 7)]

# Set Classes
mls$Zip.Code <- as.factor(mls$Zip.Code)
mls$O.Price <- as.numeric(mls$O.Price)
mls$Close.Price <- as.numeric(mls$Close.Price)
mls$CDOM <- as.numeric(mls$CDOM)
mls$Area <- as.factor(mls$Area)

# as.Date
mls$List.Date <- as.Date(mls$List.Date, format="%m/%d/%y")
mls$Close.Date <- as.Date(mls$Close.Date, format="%m/%d/%y")
mls$Expiration.Date <- as.Date(mls$Expiration.Date, format="%m/%d/%y")
mls$Pend <- as.Date(mls$Pend, format="%m/%d/%y")
mls$Tran.Date <- as.Date(mls$Tran.Date, format="%m/%d/%y")

# Subset needed columns
mls.xx <- mls[, c(1,2,4,5,9,10,16,18,20,21,39,117,136,
                  137,146,147,149,150,151,158,159,162)]
# Write to File
write.csv(mls.xx, "RMLS_Last_90_141_152_140901a.csv", row.names=FALSE)
