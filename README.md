#General Information
This script is distributed under the GNU General Public License.

Copyright 09.06.2016 Simon Gonzalez

email: s.gonzalez@griffith.edu.au

# change_labels
Labelling change in TextGrid objects

This script changes interval labels from an origin label array to a target label array.
The script works for single and multiple TextGrid selection.
If multiple TextGrid selection is speficied, the textgrids MUST be in contiguous numbers in the object window.
In the case of the labels, the script substitutes the labels following the same order in which labels are entered.

## Example

As a user, I want to change ASCII labels to Lexical Sets in TextGrid A located in tier 2.

The ASCII labels are: i E { U.

The Lexical Sets are: FLEECE DRESS TRAP FOOT.

If labels are entered in this order, all 'i' labels will change to 'FLEECE', 'E' to 'DRESS' and so on.

## Parameters

The parameters provided in the UI window are as follows:

1. Initial TextGrid number: the number of the first TextGrid in the object window.

2. Final TextGrid number: the number of the last TextGrid in the object window.

3. Tier number: the number of the tier in which labels will be changed.

4. Origin labels: the labels to be changed

5. Target labels: the labels that will substitute the origin labels.

6. Save new TextGrid: boolean - if TRUE, a new TextGrid with the changed labels will be exported.


