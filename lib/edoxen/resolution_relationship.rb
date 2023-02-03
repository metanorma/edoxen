# class ResolutionRelation {
#   source: StructuredIdentifier (Resolution)
#   destination: StructuredIdentifier (Resolution)
#   type: ResolutionRelationType
# }

# enum ResolutionRelationType {
#   annexOf {
#     This resolution is an annex to the target resolution.
#   }

#   hasAnnex {
#     The target resolution is an annex of the source resolution.
#   }

#   updates {
#     This resolution updates the target resolution.
#   }

#   refines {
#     This resolution refines the target resolution.
#   }

#   replaces/obsoletes {
#     This resolution replaces/obsoletes the target resolution.
#   }

#   considers {
#     This resolution is made in consideration of the target resolution.
#   }
# }
