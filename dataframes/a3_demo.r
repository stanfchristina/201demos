# DO THIS BEFORE EDITING ASSIGNMENT.R:
# Make /data directory to hold csv files

# Set working directory!

# VECTOR REVIEW

# Creating some loan data: two vectors, a loan ID and each loan has some credit score associated with it.
loan_id <- 1:100
credit_score <- rnorm(n = 100, mean = 600, sd = 200)

# Since we made up these credit scores, we might get some that are out of a normal range. Let's 
# corret that: simply use bracket notation to replace
credit_score[credit_score > 900] <- 900

# Now we have everything to make our dataframe.
loan_application <- data.frame(loan_id, credit_score, stringsAsFactors = FALSE);

# Say we want to add a new column to our dataframe: whether or not we should give a person a loan.
# We want to give loans to people who have credit scores over 700.
# Create column "should_loan", and assign it a boolean value saying whether or not a credit score is over 700.
loan_application$should_loan <- loan_application$credit_score >= 700

# Now I'm analysing the loan application data... how many loans am I giving out? Might be useful to know.
# Can use a boolean expression to access rows that match my criteria.
# Now that I've filtered my dataframe and know which loan applications I'm approving, I want to count them up.
nrow(loan_application[loan_application$should_loan == TRUE,])

# Write those changes to a .csv file.
write.csv(
  loan_application,
  "data/loans.csv",
  row.names = FALSE
)

##################
# DATAFRAME STUFF

# Load some sample data (iris flowers)
# Can also load a csv with read.csv("data/file_name.csv", na.rm = TRUE)

flowers <- data.frame(iris, stringsAsFactors = FALSE);

# What does the data look like? Open table in global environment.

# For the rest of the assignment, we need to be REALLY comfortable with a 2-step process:
# 1) Filtering a dataframe to get only the rows I care about
#     - this is accomplished with the row and column access syntax
# 2) With the filtered dataframe, using R functions like sum() and mean()
#     - once i have the exact data i want to know stuff about, calculate that stuff

# Aka let's say I only want the rows of my flowers dataframe where its species is "setosa"
# and its sepal length is greater than 5 inches. You can CHEAT and count these manually in the table,
# if it's not too big, but that's cheap and I'm gonna look at the number you just threw up out of 
# nowhere and know you did this and dock you down a bunch of points lol

setosa_irises <- flowers[flowers$Species == "setosa" & flowers$Sepal.Length > 5.0,]

# Easy. And now it's really easy for me to do things with this filtered dataset:

nrow(setosa_irises) # Count how many observations match
mean(setosa_irises$Sepal.Length) # Of the long-sepal setosas, I can sum up their average length.

# I can obviously do this with any dataframe, not just a filtered one:

mean_sepal_length <- mean(flowers$Sepal.Length)
mean_sepal_length_of_versicolor <- mean(flowers$Sepal.Length[flowers$Species == "versicolor"])

# I can search for the max() sepal length of a flower too: this can be a really trippy
# piece of code.
max_sepal_length <- flowers[flowers$Sepal.Length == max(flowers$Sepal.Length)]

# Quick note: dollar sign notation is finicky as fuck. Sometimes - especially if there's spaces - R has isses
# with the dollar sign so you should just use the equivalent bracket notation if that's the case.
flowers$Petal.Length
flowers[, "Petal.Length"]

# So then let's take a quick look at the homework again. We need to create a function called "survival_rate()"
# that calculates then prints a percentage about who survived on the Titanic among different passenger classes.
# This can appear intimidating. Break it down into steps:

# Look at what you have to work with.
titanic_df <- as.data.frame(Titanic, stringsAsFactors = FALSE)

survival_rate <- function(ticket_class, df) {
  # 1) do all the dataframe filtering first. E.g.
  survived <- df[df$Class == ticket_class & df$Survived == "Yes", ]
  
  # 2) do al the calculations on the dataframe.
  survived_all <- sum(survived$Freq)
  
  # 3) format stuff: round to a whole percentage
  percentage <- round(blah * 100)
  
  # 4) return your calculations according to our specified output
  output <- paste0(your stuff here)
  return(output)
}

survival_rate("1st", titanic_df)

# TLDR: Handy syntax cheatsheet from lecture slides!! have this open next to u as you work on it

#########################################
# FUNCTIONS & LAPPLY (useful for part3) #
#########################################

# Reading a .csv file
# Really important you set your working directory. kinda like using lintr and stylr, and how you loaded the image
# for the first assignment.
life_exp_df <- read.csv("data/whatever_you_named_it.csv", stringsAsFactors = FALSE)

# When creating a generic function with a dataframe, NEED to use bracket notation!
# We could use "$" notation with our titanic function because we knew exactly what the column
# names were on the titanic dataframe. Here, that is NOT the case and R can get really confused
get_column_sum <- function(column_name, df) {
  sum(df[[column_name]], na.rm = TRUE)
}

# HANDLING NA VALUES
# notice i had this "na.rm" clause - in part3 you will be working with a dataframe that is missing some values.
# This can mess up calculations like sum() and mean(), so they take in as an optional argument this na.rm = TRUE/FALSE
# thing.

# If we're working outside of those functions and want to not consider NA values while performing filtering, we need
# to use is.na() function
is.na(flowers$Sepal.Length)

# A quick note for this part along the ssame lines: the life expectancy data has columns that are labeled
# "X1998" or "X2003". This can be really confusing for people for the country_change() function, since 
# that function wants to take in two NUMERIC years, but the columns have this "X" in front of them. Solution?
# Use PASTE()

get_column_sum_life_exp <- function(year, df) {
  sum(df[[paste0("X", year)]], na.rm = TRUE)
}

get_column_sum_life_exp(2003, life_exp_df)

# The last big aspect of assignment 3 i'd like to go over is this thing called lapply that will save you
# a lot of trouble in part3. 

# Say I have a function that trims a given petal by a certain amount.
trim_petal <- function(petal, amount) {
  petal - amount
}

# I can use lapply to APPLY that function to a list or vector of values.
lapply(flowers$Petal.Length, trim_petal, 0.3)
# The parameter order is
lapply(list or vector, function to execute on each element in that list or vector, function arguments, function arguments)
# It will return a list of the same length as the one you passed in!

# Then I can write even more powerful functions to trim MULTIPLE things at once:
trim_all <- function(columns, amount) {
  lapply(columns, trim_petal, amount)
}

# Like so.
# I'd like to trim the petals and sepals of all my flowers.
# I'm going to assign to the OLD values of petal length and sepal length my NEW trimmed values.
# Here's what the dataframe looks like before: pay close attention to petal and sepal length
# Then after I execute this code, it looks like this:
flowers[, c("Petal.Length", "Sepal.Length")] <- trim_all(flowers[, c("Petal.Length", "Sepal.Length")], 0.3)
# All trimmed!

