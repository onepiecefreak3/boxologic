Boxologic
=========

A set of C programs that calculate the best fit for boxes on a pallet, and visualize the result.


Fork-specific changes
---------------------

Following things were removed from binpack.c:
- The main method

Following things were added to binpack.c:
- The exported method "create_context" to create an object holding container and box information
- The exported method "free_context" frees all allocated memory of the given context
- The method "execute_packing" executes the same methods in the same order as the original main method
- The method "get_input_file" gets the input filename of the given context
- The method "set_input_file" sets the input filename of the given context

Following things were modified in binpack.c:
- The method "report_results" takes in a context to retrieve an externally set output file to write the report to

Other undocumented modifications, that may be encountered, are either unfinished or used for debug output, not intended to be in the "final" version
