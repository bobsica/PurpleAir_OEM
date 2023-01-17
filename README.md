The purpose of these codes is to clean and average raw data from a PurpleAir sensor, and then use OEM to retrieve the coefficients for a physical calibration based on the hygroscopic growth of particulates. This process has some manual steps which should be automated in the future.

1. Download PurpleAir data for your sensor from [here](https://map.purpleair.com/). You will need the Primary (A) and Primary (B) files.

2. Run `clean_pAir.m` . The inputs to fill in are at the top of the script. If your data file includes a Daylight Savings time change, there are some lines you can un-comment around line 30-50 to deal with that. This script just cleans and averages the data, so I just print the PM, RH, and temperature variables after it runs so that I can copy+paste them into an Excel sheet (step 4). This script is functional but not optimized and not perfect. Should definitely be improved in the future if going to be used heavily.

3. The Ontario ministry data can be found [here](http://www.airqualityontario.com/history/summary.php). I manually copy+pasted the rows from the PM2.5 table into an Excel sheet.

4. In a new Excel sheet, I copy+pasted the corresponding averaged PurpleAir data from Step 2, along with the ministry data from step 3 (taking daily averages of ministry data, if needed). Doesn't matter how this is formatted, as long as you somehow make it so the `pAir_oem.m` script can read the ministry PM2.5, purpleair PM2.5, relative humidity, and temperature for each time point (either each hour or each day).

5. Run `pAir_oem.m` . Put in name of your Excel file from step 4, and adjust indices if needed so it can read the data it needs. It outputs the retrieved linear constant and bulk hygroscopicity, which can be easily applied to the calibration equation to correct the raw purpleair data (see last 2 lines of the code).
