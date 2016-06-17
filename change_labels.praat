# This script changes interval labels from an origin label array to a target label array
# The script works for single and multiple TextGrid selection
# If multiple TextGrid selection is speficied, the textgrids MUST be in contiguous numbers...
# in the object window
# In the case of the labels, the script substitutes the labels following the same order...
# in which labels are entered.
#
# This script is distributed under the GNU General Public License.
# Copyright 09.06.2016 Simon Gonzalez
# email: s.gonzalez@griffith.edu.au

#beginning of form----------------------------------------
form Change Labels
	# Object number of the first TextGrid
		positive Initial_TextGrid_number 2
	# Object number of the last TextGrid
		positive Final_TextGrid_number 2
	# -----NOTE: If only one TextGrid is specified for label change,...
	# -----		 the number of the initial TextGrid Must be the same as the final TextGrid.

	# specifies the number of tier in which labels must be changed
		positive Tier_number 1

	# input of the original labels to be changed
		sentence Origin_labels i E { $ U
	# input of the target labels that will substitute the original labels
		sentence Target_labels FLEECE DRESS TRAP THOUGHT FOOT
	# -----NOTE: labels MUST ONLY be separated by single spaces
	# -----NOTE: the number of labels MUST be the same for the Origin_labels and the Target_labels
	# -----NOTE: the label substitution follows the same order in which they are entered...
	# -----		 for example, the first label in the Origin_labels will be substituted...
	# -----		 by the first label in the Target_labels, and so on.
	
	#selects whether the changed TextGrid is saved or not
		boolean Save_new_TextGrid 1
endform
#end of form----------------------------------------------

#*******************************************************************
#*******************************************************************
#checks if any on the fields for origin and target lables is empty
#if any of the label fields is empty, the script exits
if origin_labels$ = "" or target_labels$ = ""
	if origin_labels$ != "" and target_labels$ = ""
		#if the Target Labels is empty
		exitScript: "The Target_labels field is empty.", newline$, "Please enter labels", newline$
		exitScript ( )
	elsif origin_labels$ = "" and target_labels$ != ""
		#if the Origin Labels is empty
		exitScript: "The Origin_labels field is empty.", newline$, "Please enter labels", newline$
		exitScript ( )
	elsif origin_labels$ = "" and target_labels$ = ""
		#if both label fields are empty
		exitScript: "Both label fields are empty.", newline$, "Please enter labels", newline$
		exitScript ( )
	endif
endif
#*******************************************************************
#*******************************************************************
#converts the origin lables sentence to single labels stored in an array
#stores the counter for the origin labels
	array_cntr_origin_labels = 1
#initiates the origin lables array
	tmp_arr_origin_labels$[array_cntr_origin_labels] = ""
#gets the labels and stores them in an array
#gets the length of the origin label field, including spaces
	origin_labels_length = length(origin_labels$)
	#stores the labels in single array indexes. Single spaces mark the boundaries between labels
		for i from 1 to origin_labels_length
			#stores the temporal value of the sentence
			tmp_lbl_origin_labels$ = mid$(origin_labels$,i)

			#if the temporal value is a space, a new index is added
			#if the temporal value is NOT a space, the temporal value is added to the previous label
			if tmp_lbl_origin_labels$ != " "
				tmp_arr_origin_labels$[array_cntr_origin_labels] = tmp_arr_origin_labels$[array_cntr_origin_labels] + tmp_lbl_origin_labels$
			else
				array_cntr_origin_labels = array_cntr_origin_labels + 1
				tmp_arr_origin_labels$[array_cntr_origin_labels] = ""
			endif
		endfor

#converts the target lables sentence to single labels stored in an array
#stores the counter for the target labels
	array_cntr_target_labels = 1
#initiates the target lables array
	tmp_arr_target_labels$[array_cntr_target_labels] = ""
#gets the labels and stores them in an array
#gets the length of the target label field, including spaces
	target_labels_length = length(target_labels$)
	#stores the labels in single array indexes. Single spaces mark the boundaries between labels
		for i from 1 to target_labels_length
			#stores the temporal value of the sentence
			tmp_lbl_target_labels$ = mid$(target_labels$,i)

			#if the temporal value is a space, a new index is added
			#if the temporal value is NOT a space, the temporal value is added to the previous label
			if tmp_lbl_target_labels$ != " "
				tmp_arr_target_labels$[array_cntr_target_labels] = tmp_arr_target_labels$[array_cntr_target_labels] + tmp_lbl_target_labels$
			else
				array_cntr_target_labels = array_cntr_target_labels + 1
				tmp_arr_target_labels$[array_cntr_target_labels] = ""
			endif
		endfor
#*******************************************************************
#*******************************************************************
#if the user chooses to store the changed textgrid, a new forlder is created in the same location...
#	where the script is located 
if save_new_TextGrid = 1
	system_nocheck mkdir changed_textgrids
endif

#this loop changes the labels for the textgrid(s) selected
for i from initial_TextGrid_number to final_TextGrid_number
	#selects the iterated textgrid
	selectObject: i
	#get number of intervals
	number_of_intervals = Get number of intervals... tier_number

	#checks labels in all intervals
	for j from 1 to number_of_intervals
		#get label of interval
		temporal_interval$ = Get label of interval... tier_number j

		#initiates the array index in which the index location of the origin labels is stored
		array_index = 0

		#finds the location of the temporal label in the origin labels
		for k from 1 to array_cntr_origin_labels
			if temporal_interval$ = tmp_arr_origin_labels$[k]
				array_index = k
			endif
		endfor

		#if the temporal label is found in the origin labels
		if array_index > 0
			tmp_lbl$ = tmp_arr_target_labels$[array_index]
			#changes the origin label to the target label
			Set interval text... tier_number j 'tmp_lbl$'
		endif

	endfor

	#if the user selects to save the changed textgrid
	if save_new_TextGrid = 1
		textGrid_name$ = selected$ ("TextGrid")
		full_name_table$ = "changed_textgrids/" + textGrid_name$ + ".TextGrid"
		Save as text file: full_name_table$
	endif

endfor
