if (sliceCode == CODE_ARGS)
   {
    ArrayNum = argVal( "an" );   /* Array size of arrayed parameter */
    SpecNum = argVal( "sn" );    /* Spectrum number to be extracted */
    printf(" Spectrum %3.0f out of %4.0f\n",SpecNum,ArrayNum);
   };

if (sliceCode == CODE_INIT)
   {
    (void) setParm( fdata, NDSIZE, integer( specnum/ArrayNum ), CUR_YDIM );
   };

if (sliceCode >1)
   {
    exit( 0 );
   };

if (sliceCode < 0)
   {
    exit( 0 );
   };


float fid[2*size*specnum];
float Single[4*size];

(void) dReadB(inUnit,fid, 2*wordLen*size*specnum );     /* load the whole FID data in the array "fid" */

offset = 4*size*(SpecNum-1);

for( i = 0; i < specnum*size*2; i = i+4*ArrayNum*size)
{
 (void) vvCopyOff( Single, fid, 4*size, 0, offset );    /* load in the buffer array "Single" two complex spectra
                                                           (phase=1,phase=2) from the "fid" array starting from offset*/
 (void) dWrite( outUnit,Single,wordLen*4*size);         /* write "Single in the output */
 offset += 4*ArrayNum*size;
}
