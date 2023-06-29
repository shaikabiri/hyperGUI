
# 
# # Loop through the list of packages
# for (package_name in packages) {
#   # Check if the package is already installed
#   if (!requireNamespace(package_name, quietly = TRUE)) {
#     # If not installed, install the package
#     install.packages(package_name)
#   }
#   
#   # Load the package
#   library(package_name, character.only = TRUE)
# }
