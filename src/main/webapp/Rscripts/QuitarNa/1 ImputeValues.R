#===========================================#
#				IMPUTATION OF MATRICIAL VALUES			#
#			METHOD: KNN (K-NEAREST NEIGHBOURS)		#
#===========================================#

# Description: 
# 	This function takes a numeric matrix with NAs, and fills
# 	them with numbers through the knn method, what is an estimation of
# 	the original values that match there.

# Where:
#	A <- matrix to be imputated (has NAs)
#	k <- k-nearest neighbours used for the imputation

imputeValues <- function(A, k=3){

  # if (!requireNamespace("BiocManager", quietly = TRUE))
  #   install.packages("BiocManager")
  # 
  # impute_installed <- suppressPackageStartupMessages(require('impute'))
  # if (!impute_installed)
  #   BiocManager::install("impute")
  
	# Loading the library needed for the main function
	suppressPackageStartupMessages(library(impute))
	
	#convert to matrix
	A<-as.matrix(A)
	# Doing the imputation
	Aestimated <- impute.knn(A, k, rowmax=0.99, colmax=0.99);

	# Returning the imputated matrix
	return (Aestimated);

}
