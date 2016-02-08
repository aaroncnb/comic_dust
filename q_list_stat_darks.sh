q_fcombine m89031 m89033 ave=DI_50_1_1_ave
##Imaging

##Darks for N11.7
q_list_stat COMA00089023.fits 1 - - : m89023
q_list_stat COMA00089025.fits 1 - - : m89025
q_list_stat COMA00089025.fits 1 - - : m89027
q_list_stat COMA00089025.fits 1 - - : m89029

q_fcombine m89023 m89025 m89027 m89029 ave=DI30_1_1_ave

q_arith DI30_1_1_ave / 16.0 DI30_1_1

##Darks for N8.8
q_list_stat COMA00089031.fits 1 - - : m89031
q_list_stat COMA00089033.fits 1 - - : m89033

q_fcombine m89031 m89033 ave=DI_50_1_1_ave

q_arith DI50_1_1_ave / 9.0 DI50_1_1

##Darks Q18.8
q_list_stat COMA00089019.fits 1 - - : m89019
q_list_stat COMA00089021.fits 1 - - : m89021

q_fcombine m89019 m89021 ave=DI30_120_1_ave

q_arith DI30_120_1_ave / 16.0 DI30_120_1

##Q24.5- Same as N11.7!
#q_list_stat COMA00089023.fits 1 - - : m89023
#q_list_stat COMA00089025.fits 1 - - : m89025
#q_list_stat COMA00089025.fits 1 - - : m89027
#q_list_stat COMA00089025.fits 1 - - : m89029

#q_fcombine m89023 m89025 m89027 m89029 ave=DI30_1_1_ave

#q_arith DI30_1_1_ave / 16.0 DI30_1_1

##Spectroscopy
##NL
q_list_stat COMA00089052.fits 1 - - : m89052
q_list_stat COMA00089054.fits 1 - - : m89054

q_fcombine m89052 m89054 ave=DS150_1_1_ave

q_arith DS150_1_1_ave / 32.0 DS150_1_1

###FLAT####

q_list_stat COMA00089040.fits 1 - - : m89040
q_list_stat COMA00089042.fits 1 - - : m89042
q_list_stat COMA00089044.fits 1 - - : m89044
q_list_stat COMA00089046.fits 1 - - : m89046

##Make the FLATs averaged Dark, from the individual dark frames

q_fcombine m89040 m89042 m89044 m89046 ave=DS50_1_1

##Get the typical value "per Nexp" (in this case, 98)

q_arith DS50_1_1_ave / 98.0 DS50_1_1

#Now that we have the flat's dark, subtract it from the flat, itself

q_list_stat COMA00088272.fits 1 - - : DOMEFLAT_NL_STD

##First you have to scale the dark up to the same Nexp as the flat

q_arith DS50_1_1 \* 9.0 FDARK1

##Now you can actually subtract it

q_arith DOMEFLAT_NL_STD - FDARK1 FLAT_NL_TEST_STD

##Now we're gonna get the average value of the flat, so that we can
##normalize it

q_list_stat FLAT_NL_TEST_STD 1 1:320 32:240 1 | awk '{print $5}'

##Taking the value output by q_list_stat, we do the actual noramlization
##(In this case, it was 5.368803e+03)
## "OBJ1" is IRAS18434

q_arith FLAT_NL_TEST_STD / 5.368803e+03 FLAT_NL_STD

###Done!#
###Actually we're not done yet: Our observation set contains TWO flats
### One is for the standard star observation
### The other is for our target observation
### So we need to repeat the flat steps above for the target
### See 5.1.4 in the COMICS Cookbook: 



##88380 is the target's FLAT file
q_list_stat COMA00088380.fits 1 - - : DOMEFLAT_NL_OBJ

q_arith DOMEFLAT_NL_OBJ - FDARK1 FLAT_NL_TEST_OBJ

q_list_stat FLAT_NL_TEST_OBJ 1 1:320 32:240 1 | awk '{print $5}'

## In the Object-Flat case, the average is 5.421052e+03

q_arith FLAT_NL_TEST_OBJ / 5.421052e+03 FLAT_NL_OBJ



######Actually Done!! (With Treating the Flats)#######


###Next: A different kind of noise reduction, "Redout Noise Pattern Correction
## First, we make "COMQ" files from the "COMA" files.
## The COMA files have two frames- one's the spectral data, the other's just a "guide 
## image"
## The guide image isn't really needed, BUT- the cool thing is, it has the same
## noise pattern as the spectral data. So we can easily extract the readout noise 
## pattern from the guide image, and then subtract this pattern from the spectral data

###First, we'll do it for the standard star observations (just one exposure)
###aftr that, we'll do it for the IRAS18434 target observations 
###(there's 16 exposures total), This means 8 of position b, 8 pos. a


####Starting Standard Star Flat correction
#This is not enough to make COMQ from COMA!
# "q_bsep" is needed!!
# otherwise, we'll need to start with the 'ready-made' COMQ .FITS files
q_list_stat COMA00088270.fits 1 - - 1 DATA.fits
q_list_stat COMA00088270.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_STD.REF
q_arith DATA.fits - NC_STD.REF COMQ_NL_STD_A01_NC.fits


###Starting position A
q_list_stat COMA00088316.fits 1 - - 1 DATA.fits
q_list_stat COMA00088316.fits 2	- - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A01_NC.fits
q_list_stat COMA00088318.fits 1	- - 1 DATA.fits
q_list_stat COMA00088318.fits 2 - - 1 REF.fits
q_subch	REF.fits REF NC_OBJ.REF
q_arith	DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A02_NC.fits
q_list_stat COMA00088320.fits 1	- - 1 DATA.fits
q_list_stat COMA00088320.fits 2 - - 1 REF.fits
q_subch	REF.fits REF NC_OBJ.REF
q_arith	DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A03_NC.fits
q_list_stat COMA00088322.fits 1	- - 1 DATA.fits
q_list_stat COMA00088322.fits 2 - - 1 REF.fits
q_subch	REF.fits REF NC_OBJ.REF
q_arith	DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A04_NC.fits
q_list_stat COMA00088324.fits 1	- - 1 DATA.fits
q_list_stat COMA00088324.fits 2 - - 1 REF.fits
q_subch	REF.fits REF NC_OBJ.REF
q_arith	DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A05_NC.fits
q_list_stat COMA00088326.fits 1 - - 1 DATA.fits
q_list_stat COMA00088326.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A06_NC.fits
q_list_stat COMA00088328.fits 1 - - 1 DATA.fits
q_list_stat COMA00088328.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A07_NC.fits
q_list_stat COMA00088330.fits 1 - - 1 DATA.fits
q_list_stat COMA00088330.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_STD_A08_NC.fits
q_list_stat COMA00088332.fits 1 - - 1 DATA.fits
q_list_stat COMA00088332.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A09_NC.fits
q_list_stat COMA00088334.fits 1 - - 1 DATA.fits
q_list_stat COMA00088334.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A10_NC.fits
q_list_stat COMA00088336.fits 1 - - 1 DATA.fits
q_list_stat COMA00088336.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A11_NC.fits
q_list_stat COMA00088338.fits 1 - - 1 DATA.fits
q_list_stat COMA00088338.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A12_NC.fits
q_list_stat COMA00088340.fits 1 - - 1 DATA.fits
q_list_stat COMA00088340.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A13_NC.fits
q_list_stat COMA00088342.fits 1 - - 1 DATA.fits
q_list_stat COMA00088342.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A14_NC.fits
q_list_stat COMA00088344.fits 1 - - 1 DATA.fits
q_list_stat COMA00088344.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A15_NC.fits
q_list_stat COMA00088346.fits 1 - - 1 DATA.fits
q_list_stat COMA00088346.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_A16_NC.fits



########Make COMQs for Position 2 ("B")
q_list_stat COMA00088348.fits 1 - - 1 DATA.fits
q_list_stat COMA00088348.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B01_NC.fits
q_list_stat COMA00088350.fits 1 - - 1 DATA.fits
q_list_stat COMA00088350.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B02_NC.fits
q_list_stat COMA00088352.fits 1 - - 1 DATA.fits
q_list_stat COMA00088352.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B03_NC.fits
q_list_stat COMA00088354.fits 1 - - 1 DATA.fits
q_list_stat COMA00088354.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B04_NC.fits
q_list_stat COMA00088356.fits 1 - - 1 DATA.fits
q_list_stat COMA00088356.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B05_NC.fits
q_list_stat COMA00088358.fits 1 - - 1 DATA.fits
q_list_stat COMA00088358.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B06_NC.fits
q_list_stat COMA00088360.fits 1 - - 1 DATA.fits
q_list_stat COMA00088360.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B07_NC.fits
q_list_stat COMA00088362.fits 1 - - 1 DATA.fits
q_list_stat COMA00088362.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B08_NC.fits
q_list_stat COMA00088364.fits 1 - - 1 DATA.fits
q_list_stat COMA00088364.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B09_NC.fits
q_list_stat COMA00088366.fits 1 - - 1 DATA.fits
q_list_stat COMA00088366.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B10_NC.fits
q_list_stat COMA00088368.fits 1 - - 1 DATA.fits
q_list_stat COMA00088368.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B11_NC.fits
q_list_stat COMA00088370.fits 1 - - 1 DATA.fits
q_list_stat COMA00088370.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B12_NC.fits
q_list_stat COMA00088372.fits 1 - - 1 DATA.fits
q_list_stat COMA00088372.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B13_NC.fits
q_list_stat COMA00088374.fits 1 - - 1 DATA.fits
q_list_stat COMA00088374.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B14_NC.fits
q_list_stat COMA00088376.fits 1 - - 1 DATA.fits
q_list_stat COMA00088376.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B15_NC.fits
q_list_stat COMA00088378.fits 1 - - 1 DATA.fits
q_list_stat COMA00088378.fits 2 - - 1 REF.fits
q_subch REF.fits REF NC_OBJ.REF
q_arith DATA.fits - NC_OBJ.REF COMQ_NL_OBJ_B16_NC.fits


#############Now that the COMQs and Flats prepared
############ we can finally divide the COMQs by the flats

##Standard Star Flat Correction
q_arith COMQ_NL_STD_A01_NC.fits / FLAT_NL_STD NL_STD_NC_FC_A01.fits

##Observation Flat Correction: Position A
q_arith COMQ_NL_OBJ_A01_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A01.fits
q_arith COMQ_NL_OBJ_A02_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A02.fits
q_arith COMQ_NL_OBJ_A03_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A03.fits
q_arith COMQ_NL_OBJ_A04_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A04.fits
q_arith COMQ_NL_OBJ_A05_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A05.fits
q_arith COMQ_NL_OBJ_A06_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A06.fits
q_arith COMQ_NL_OBJ_A07_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A07.fits
q_arith COMQ_NL_OBJ_A08_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A08.fits
q_arith COMQ_NL_OBJ_A09_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A09.fits
q_arith COMQ_NL_OBJ_A10_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A10.fits
q_arith COMQ_NL_OBJ_A11_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A11.fits
q_arith COMQ_NL_OBJ_A12_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A12.fits
q_arith COMQ_NL_OBJ_A13_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A13.fits
q_arith COMQ_NL_OBJ_A14_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A14.fits
q_arith COMQ_NL_OBJ_A15_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A15.fits
q_arith COMQ_NL_OBJ_A16_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_A16.fits

##Observation Flat Correction: Positon B
q_arith COMQ_NL_OBJ_B01_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B01.fits
q_arith COMQ_NL_OBJ_B02_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B02.fits
q_arith COMQ_NL_OBJ_B03_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B03.fits
q_arith COMQ_NL_OBJ_B04_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B04.fits
q_arith COMQ_NL_OBJ_B05_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B05.fits
q_arith COMQ_NL_OBJ_B06_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B06.fits
q_arith COMQ_NL_OBJ_B07_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B07.fits
q_arith COMQ_NL_OBJ_B08_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B08.fits
q_arith COMQ_NL_OBJ_B09_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B09.fits
q_arith COMQ_NL_OBJ_B10_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B10.fits
q_arith COMQ_NL_OBJ_B11_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B11.fits
q_arith COMQ_NL_OBJ_B12_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B12.fits
q_arith COMQ_NL_OBJ_B13_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B13.fits
q_arith COMQ_NL_OBJ_B14_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B14.fits
q_arith COMQ_NL_OBJ_B15_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B15.fits
q_arith COMQ_NL_OBJ_B16_NC.fits / FLAT_NL_OBJ NL_OBJ_NC_FC_B16.fits



########Next we make the sky images

##Make FDARK for NL mode
q_list_stat COMA00088270.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK
q_arith COMA_NL.fits - FDARK1 SKY_NL_STD_A01.fits


##Observation: Position A
q_list_stat COMA00088316.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A01.fits

q_list_stat COMA00088318.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A02.fits

q_list_stat COMA00088320.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A03.fits

q_list_stat COMA00088322.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A04.fits

q_list_stat COMA00088324.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A05.fits

q_list_stat COMA00088326.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A06.fits

q_list_stat COMA00088328.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A07.fits

q_list_stat COMA00088330.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A08.fits

q_list_stat COMA00088332.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A09.fits

q_list_stat COMA00088334.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A10.fits

q_list_stat COMA00088336.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A11.fits

q_list_stat COMA00088338.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A12.fits

q_list_stat COMA00088340.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A13.fits

q_list_stat COMA00088342.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A14.fits

q_list_stat COMA00088344.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A15.fits

q_list_stat COMA00088346.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_A16.fits


##Observation: Position B
q_list_stat COMA00088348.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B01.fits

q_list_stat COMA00088350.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B02.fits

q_list_stat COMA00088352.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B03.fits

q_list_stat COMA00088354.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B04.fits

q_list_stat COMA00088356.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B05.fits

q_list_stat COMA00088358.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B06.fits

q_list_stat COMA00088360.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B07.fits

q_list_stat COMA00088362.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B08.fits

q_list_stat COMA00088364.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B09.fits

q_list_stat COMA00088366.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B10.fits

q_list_stat COMA00088368.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B11.fits

q_list_stat COMA00088370.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B12.fits

q_list_stat COMA00088372.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B13.fits

q_list_stat COMA00088374.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B14.fits

q_list_stat COMA00088376.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B15.fits

q_list_stat COMA00088378.fits 1 - - : COMA_NL.fits
q_arith DS150_1_1 \* 3.0 FDARK1
q_arith COMA_NL.fits - FDARK1 SKY_NL_OBJ_B16.fits



### Next let's obtain the spatially constant axis
# This part just scales the values by 100, so that the next 
# step runs faster..or so I think
q_arith COMQ_NL_STD_A01_NC.fits / 100.0 SCALE1
#q_startrace doesn't do the 2D function fitting...
# it just finds the peak position
q_startrace SCALE1 1 180-220 28:40 1 | awk '{print $2,$10}' > SPATIAL_CONST_STD_A01.DAT

##Now do the same commands for the "Objects" A and B (actally the same object, but different positons)

q_arith COMQ_NL_OBJ_A01_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A01.DAT

q_arith COMQ_NL_OBJ_A02_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A02.DAT

q_arith COMQ_NL_OBJ_A03_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A03.DAT

q_arith COMQ_NL_OBJ_A04_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A04.DAT

q_arith COMQ_NL_OBJ_A05_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A05.DAT

q_arith COMQ_NL_OBJ_A06_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A06.DAT

q_arith COMQ_NL_OBJ_A07_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A07.DAT

q_arith COMQ_NL_OBJ_A08_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A08.DAT

q_arith COMQ_NL_OBJ_A09_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A09.DAT

q_arith COMQ_NL_OBJ_A10_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A10.DAT

q_arith COMQ_NL_OBJ_A11_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A11.DAT

q_arith COMQ_NL_OBJ_A12_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A12.DAT

q_arith COMQ_NL_OBJ_A13_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A13.DAT

q_arith COMQ_NL_OBJ_A14_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A14.DAT

q_arith COMQ_NL_OBJ_A15_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A15.DAT

q_arith COMQ_NL_OBJ_A16_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_A16.DAT


########Object B:

q_arith COMQ_NL_OBJ_B01_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44  1| awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B01.DAT

q_arith COMQ_NL_OBJ_B02_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B02.DAT

q_arith COMQ_NL_OBJ_B03_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B03.DAT

q_arith COMQ_NL_OBJ_B04_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B04.DAT

q_arith COMQ_NL_OBJ_B05_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B05.DAT

q_arith COMQ_NL_OBJ_B06_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B06.DAT

q_arith COMQ_NL_OBJ_B07_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B07.DAT

q_arith COMQ_NL_OBJ_B08_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B08.DAT

q_arith COMQ_NL_OBJ_B09_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B09.DAT

q_arith COMQ_NL_OBJ_B10_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B10.DAT

q_arith COMQ_NL_OBJ_B11_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B11.DAT

q_arith COMQ_NL_OBJ_B12_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B12.DAT

q_arith COMQ_NL_OBJ_B13_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B13.DAT

q_arith COMQ_NL_OBJ_B14_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B14.DAT

q_arith COMQ_NL_OBJ_B15_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B15.DAT

q_arith COMQ_NL_OBJ_B16_NC.fits / 100.0 SCALE1
q_startrace SCALE1 1 180-220 20:44 1 | awk '{print $2,$10}' > SPATIAL_CONST_OBJ_B16.DAT


###Standard Star: Find the wavelength/pixel relationship!



q_sky_nlow SKY_NL_STD_A01.fits 1 - default 1 2 > SKY_NL_STD_A01.res

###Observation target: Find the wavelength/pixel relationship for position A
q_sky_nlow SKY_NL_OBJ_A02.fits 1 - default 1 2 > SKY_NL_OBJ_A01.res
q_sky_nlow SKY_NL_OBJ_A02.fits 1 - default 1 2 > SKY_NL_OBJ_A02.res
q_sky_nlow SKY_NL_OBJ_A03.fits 1 - default 1 2 > SKY_NL_OBJ_A03.res
q_sky_nlow SKY_NL_OBJ_A04.fits 1 - default 1 2 > SKY_NL_OBJ_A04.res
q_sky_nlow SKY_NL_OBJ_A05.fits 1 - default 1 2 > SKY_NL_OBJ_A05.res
q_sky_nlow SKY_NL_OBJ_A06.fits 1 - default 1 2 > SKY_NL_OBJ_A06.res
q_sky_nlow SKY_NL_OBJ_A07.fits 1 - default 1 2 > SKY_NL_OBJ_A07.res
q_sky_nlow SKY_NL_OBJ_A08.fits 1 - default 1 2 > SKY_NL_OBJ_A08.res
q_sky_nlow SKY_NL_OBJ_A09.fits 1 - default 1 2 > SKY_NL_OBJ_A09.res
q_sky_nlow SKY_NL_OBJ_A10.fits 1 - default 1 2 > SKY_NL_OBJ_A10.res
q_sky_nlow SKY_NL_OBJ_A11.fits 1 - default 1 2 > SKY_NL_OBJ_A11.res
q_sky_nlow SKY_NL_OBJ_A12.fits 1 - default 1 2 > SKY_NL_OBJ_A12.res
q_sky_nlow SKY_NL_OBJ_A13.fits 1 - default 1 2 > SKY_NL_OBJ_A13.res
q_sky_nlow SKY_NL_OBJ_A14.fits 1 - default 1 2 > SKY_NL_OBJ_A14.res
q_sky_nlow SKY_NL_OBJ_A15.fits 1 - default 1 2 > SKY_NL_OBJ_A15.res
q_sky_nlow SKY_NL_OBJ_A16.fits 1 - default 1 2 > SKY_NL_OBJ_A16.res


###Observation target: Find the wavelength/pixel relationship for position B
q_sky_nlow SKY_NL_OBJ_B01.fits 1 - default 1 2 > SKY_NL_OBJ_B01.res
q_sky_nlow SKY_NL_OBJ_B02.fits 1 - default 1 2 > SKY_NL_OBJ_B02.res
q_sky_nlow SKY_NL_OBJ_B03.fits 1 - default 1 2 > SKY_NL_OBJ_B03.res
q_sky_nlow SKY_NL_OBJ_B04.fits 1 - default 1 2 > SKY_NL_OBJ_B04.res
q_sky_nlow SKY_NL_OBJ_B05.fits 1 - default 1 2 > SKY_NL_OBJ_B05.res
q_sky_nlow SKY_NL_OBJ_B06.fits 1 - default 1 2 > SKY_NL_OBJ_B06.res
q_sky_nlow SKY_NL_OBJ_B07.fits 1 - default 1 2 > SKY_NL_OBJ_B07.res
q_sky_nlow SKY_NL_OBJ_B08.fits 1 - default 1 2 > SKY_NL_OBJ_B08.res
q_sky_nlow SKY_NL_OBJ_B09.fits 1 - default 1 2 > SKY_NL_OBJ_B09.res
q_sky_nlow SKY_NL_OBJ_B10.fits 1 - default 1 2 > SKY_NL_OBJ_B10.res
q_sky_nlow SKY_NL_OBJ_B11.fits 1 - default 1 2 > SKY_NL_OBJ_B11.res
q_sky_nlow SKY_NL_OBJ_B12.fits 1 - default 1 2 > SKY_NL_OBJ_B12.res
q_sky_nlow SKY_NL_OBJ_B13.fits 1 - default 1 2 > SKY_NL_OBJ_B13.res
q_sky_nlow SKY_NL_OBJ_B14.fits 1 - default 1 2 > SKY_NL_OBJ_B14.res
q_sky_nlow SKY_NL_OBJ_B15.fits 1 - default 1 2 > SKY_NL_OBJ_B15.res
q_sky_nlow SKY_NL_OBJ_B16.fits 1 - default 1 2 > SKY_NL_OBJ_B16.res




