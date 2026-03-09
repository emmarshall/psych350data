library(psych350data)

### Check that all datasets load and are recognized:

# Should return all current datasets names with no errors
list_datasets()

# Spot check a few
data(parent_child_data)
data(hindsight_bg_data)
data(hindsight_wg_data)
data(cheese_data)
data(lpd_data)

# 2. Check prep_data() works for each new dataset:

# Pass-through datasets — should return identical to input
prep_data(parent_child_data,  "parent_child_data")
prep_data(hindsight_bg_data,  "hindsight_bg_data")
prep_data(hindsight_wg_data,  "hindsight_wg_data")

# Cheese — check milk_source and vegetarian are integer after prep
prepped_cheese <- prep_data(cheese_data, "cheese_data")
class(prepped_cheese$milk_source)   # should be "integer"
class(prepped_cheese$vegetarian)    # should be "integer"

# LPD — check all four categoricals are integer after prep
prepped_lpd <- prep_data(lpd_data, "lpd_data")
class(prepped_lpd$race)         # should be "integer"
class(prepped_lpd$gender)       # should be "integer"
class(prepped_lpd$result)       # should be "integer"
class(prepped_lpd$time_of_day)  # should be "integer"

#3. Check keep_labels works:
# Cheese — should have milk_source_label and vegetarian_label columns
cheese_labelled <- prep_data(cheese_data, "cheese_data", keep_labels = TRUE)
c("milk_source_label", "vegetarian_label") %in% names(cheese_labelled)

# LPD — should have _label columns for all four categoricals
lpd_labelled <- prep_data(lpd_data, "lpd_data", keep_labels = TRUE)
c("race_label", "gender_label", "result_label", "time_of_day_label") %in% names(lpd_labelled)

#4. Check export functions work:
# Export each new dataset and verify the .sav is created
export_parent_child_sav("test_parent_child.sav")
export_hindsight_bg_sav("test_hindsight_bg.sav")
export_hindsight_wg_sav("test_hindsight_wg.sav")
export_cheese_sav("test_cheese.sav")
export_lpd_sav("test_lpd.sav")

# Verify files exist
file.exists(c(
  "test_parent_child.sav",
  "test_hindsight_bg.sav",
  "test_hindsight_wg.sav",
  "test_cheese.sav",
  "test_lpd.sav"
))

#5. Check SPSS metadata is intact on exported files:
  rlibrary(labelled)

# Pick one exported file and audit it
check_sav_export("test_cheese.sav",       show_all = TRUE)
check_sav_export("test_lpd.sav",          show_all = TRUE)
check_sav_export("test_parent_child.sav", show_all = TRUE)
check_sav_export("test_hindsight_bg.sav", show_all = TRUE)
check_sav_export("test_hindsight_wg.sav", show_all = TRUE)

#6. Run a quick build check:
#  From package root — should show no ERRORs or WARNINGs

#devtools::check()
