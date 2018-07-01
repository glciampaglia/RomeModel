Organization of this subtree
----------------------------
Any top-level folder refers to a single graph or plotting. Inside any folder
there must be the script do_plot.m. This script executes the MATLAB commands to
produce the plot. The script should generate a FIG file and an EPS file.

An exception is the folder utils/ that contains general functions that can be
reused by all scripts.
