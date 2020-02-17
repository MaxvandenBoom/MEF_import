// Copyright 2020 Richard J. Cui. Created: Sun 02/16/2020 10:34:49.777 PM
// $Revision: 0.1 $  $Date: Sun 02/16/2020 10:34:49.777 PM $
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

mxArray *mxDoubleByValue(sf8 value);
mxArray *mxUInt32ByValue(ui4 value);
mxArray *mxInt8ByValue(si1 value);
mxArray *mxInt32ByValue(si4 value);
mxArray *mxInt64ByValue(si8 value);
mxArray *mxStringByUTF8Value(char *str);


#endif   // MEX_DATAHELPER_