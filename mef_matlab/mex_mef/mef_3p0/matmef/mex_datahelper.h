// Copyright 2020 Richard J. Cui. Created: Sun 02/16/2020 10:34:49.777 PM
// $Revision: 0.2 $  $Date: Mon 02/17/2020  8:15:44.891 PM $
//
// 1026 Rocky Creek Dr NE
// Rochester, MN 55906, USA
//
// Email: richard.cui@utoronto.ca

#ifndef MEX_DATAHELPER_
#define MEX_DATAHELPER_
/**
 *
 * 	@file - header
 *
 *
 */
#include "mex.h"
#include "meflib.h"

mxArray *mxFillNumericArray(ui1 *array, int num_bytes);
mxArray *mxDoubleByValue(sf8 value);
mxArray *mxUInt32ByValue(ui4 value);
mxArray *mxInt8ByValue(si1 value);
mxArray *mxInt32ByValue(si4 value);
mxArray *mxInt64ByValue(si8 value);
mxArray *mxStringByUTF8Value(char *str);


#endif   // MEX_DATAHELPER_