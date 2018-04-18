#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Script to test for duplicates in species naming (the network data).
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

library(data.table)

# Read data
network_orig <- read.csv("data/Rom_Trans_cor_new.csv")
net2check <- network_orig


# Simple check ------------------------------------------------------------

# Check for duplicates in Plants.
# integer(0) indicates no duplicates
which(table(net2check$Plants) != 1)

# Check for duplicates in column names (Pollinators)
# First substitute dot/multiple dots with space
names(net2check) <- gsub(pattern = "\\.+",
                         replacement = " ",
                         x = names(net2check))
# which name appears more than once?
which(table(names(net2check)) != 1) 
# Previously was an issue with Eristalis tenax (data was corrected meanwhile)


# Check & correct ---------------------------------------------------------
# In case of no duplicates, stop here with the checking and run ro_bipartite_network.r

# How are the duplicates looking like?
names(network_orig)[names(network_orig) %like% "Eristalis.+tenax"]
# [1] "Eristalis.tenax"  "Eristalis..tenax"

# Combine "Eristalis.tenax" with "Eristalis..tenax"
# and delete "Eristalis..tenax" column
setDT(network_orig)
network_orig[, .(Eristalis.tenax, Eristalis..tenax)] # check values
network_orig[, Eristalis.tenax := Eristalis.tenax + Eristalis..tenax] # combine
network_orig[, Eristalis..tenax := NULL] # delete column


# Save file to be used further in ro_bipartite_network.r script 
write.csv(network_orig, 
          file = "data/Rom_Trans_cor.csv", # change name if needed
          row.names = FALSE)
