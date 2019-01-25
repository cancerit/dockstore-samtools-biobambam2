# Changes

## 0.0.4

- replace characters that violate CWL file names rules in bamtofastq output fastq file names to '_', and do the same for the RG_IDs in the output rg_info json file.

## 0.0.3

- Missed updating CWL and docs for change to ref_path
- Added details to this file for 0.0.2
- Fixed dockerfile label to have correct version number (was 1.0.0?)

## 0.0.2

- Handles BAM/CRAM files where a read may not have the RG tag assigned and result in default output files.
- Handled BAM/CRAM with no headers at all, previously errored.
- Orphans and singletons to /dev/null as this workflow will not expose them.
- Changes ref_path variable to add the 'URL=' prefix internally as for this instance it is not possible to provide a
  local expansion as we don't know the incoming genome/build.

## 0.0.1

- Initial tagged release
