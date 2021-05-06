
# Transform schema of Parciales to match schema of Todo
cols_to_factor = names(Filter(is.factor, Todo))
cols_to_numeric = names(Filter(is.numeric, Todo[, 1:28]))
cols_to_numeric = cols_to_numeric[which(cols_to_numeric != "Carnet")]

for (col in cols_to_factor) {
  Parciales[, col] <- as.factor(Parciales[, col])
}

for (col in cols_to_numeric) {
  Parciales[, col] <- as.numeric(Parciales[, col])
}
