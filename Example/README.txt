An example of running these codes.

July_A and July_B are the raw data files from the PurpleAir website. I run these through 'clean_pAir.m', and then copy+paste the PM2.5, RH, and temperatures into 'averaged_data.xlsx' . I also copy the day (and hour) of each data point so that I can see if/where there is any missing PurpleAir data.

'Ministry.xlsx' is the data copied straight from the ministry site. I copy+paste the desired data into the 'averaged_data.xlsx' alongside the PurpleAir data, deleting any ministry data that does not have a corresponding PurpleAir reading.

I run 'averaged_data.xlsx' through the 'pAir_oem.m' script to get the retrieved values for the calibration constant 'c' and the bulk hygroscopicity 'k' (with this July data, using hourly averages, c=1.89 and k=0.48).