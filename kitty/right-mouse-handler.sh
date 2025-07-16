#!/bin/bash
# Check if there's a selection by trying to get clipboard content from selection
SELECTION=$(kitten @ get-text --extent=selection 2>/dev/null)
if [[ "x$SELECTION" == "x" ]] then
    # No selection - paste
    kitten @ action paste_from_clipboard
else
    # There is a selection - copy it and clear
    kitten @ action copy_to_clipboard
    kitten @ action clear_selection
    # kitten @ send-text --stdin <<< $'\e'  # Send escape to clear selection
fi
