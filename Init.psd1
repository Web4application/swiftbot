# A $MFT file on a mounted partition should be specified.
# For instance, to extract $MFT data from a forensics image, the image should first be mounted and the $MFT specified as <DRIVER_LETTER:\$MFT to MFTECmd.exe.

MFTECmd.exe -f '<$MFT_FILE>' --csv <OUTPUTDIR_PATH>
