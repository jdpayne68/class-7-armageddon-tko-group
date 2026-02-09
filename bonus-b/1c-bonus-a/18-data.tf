############################################
# Bonus A - Data + Locals
############################################

# Explanation: armageddon wants to know “who am I in this galaxy?” so ARNs can be scoped properly.
data "aws_caller_identity" "armageddon_self01" {}

# Explanation: Region matters—hyperspace lanes change per sector.
data "aws_region" "armageddon_region01" {}
