// READ_MEF_HEADER_MEX_3P0 mex gatefun to read universal header of data series segment
//
// See read_mef_header_mex_3p0.m for details of usage.

// Copyright 2020 Richard J. Cui. Created: Sun 02/02/2020  5:18:29.851 PM
// $Revision: 0.1 $  $Date: Sun 02/02/2020  5:18:29.851 PM $
//
// 1026 Rocky Creek Dr NE
// Rochester, MN 55906, USA
//
// Email: richard.cui@utoronto.ca

#include <ctype.h>
#include "mex.h"
#include "matmef/meflib/meflib/meflib.h"
#include "matmef/matmef_mapping.h"

// Universal Header Structures
const int SEG_UNIVERSAL_HEADER_NUMFIELDS		= 21;
const char *SEG_UNIVERSAL_HEADER_FIELDNAMES[] 	= {
    "header_CRC",
    "body_CRC",
    "file_type_string",
    "mef_version_major",
    "mef_version_minor",
    "byte_order_code",
    "start_time",
    "end_time",
    "number_of_entries",
    "maximum_entry_size",
    "segment_number",
    "channel_name",					// utf8[63], base name only, no extension
    "session_name",					// utf8[63], base name only, no extension
    "anonymized_name",				// utf8[63]
    "level_UUID",
    "file_UUID",
    "provenance_UUID",
    "level_1_password_validation_field",
    "level_2_password_validation_field",
    "protected_region",
    "discretionary_region"
};

/**************************************************************************
 * subroutines
 *************************************************************************/
void map_mef3_segment_universal_header_tostruct(
        UNIVERSAL_HEADER *universal_header, // universal header of 1st segment
        si1 map_indices_flag,
        mxArray *mat_universal_header,
        int mat_index // index of structure matrix
        ) {
}

mxArray *map_mef3_segment_universal_header(
        UNIVERSAL_HEADER *universal_header,
        si1 map_indices_flag) {
    
    mxArray *mat_universal_header;
    int mat_index = 0;
    
    mat_universal_header = mxCreateStructMatrix(1, 1,
            SEG_UNIVERSAL_HEADER_NUMFIELDS, SEG_UNIVERSAL_HEADER_FIELDNAMES);
    map_mef3_segment_universal_header_tostruct(universal_header,
            map_indices_flag, mat_universal_header, mat_index);
    
    return mat_universal_header;
}

/**************************************************************************
 * main entrence
 *************************************************************************/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    // vars declare
    si1 channel_path[MEF_FULL_FILE_NAME_BYTES];
    char *mat_channel_path, *mat_password;
    si1 *password = NULL;
    si1 password_arr[PASSWORD_BYTES] = {0};
    si1 map_indices_flag = 0;
    si1 mat_map_indices_flag;
    CHANNEL *channel;
    
    // ***** channel_path *****
    // check input prhs[0]: channel_path (required)
    if (nrhs < 1) {
        mexErrMsgIdAndTxt("read_mef_header_mex_3p0:noChannelPathArg",
                "channel_path input argument is required");
    }
    else {
        if (mxIsEmpty(prhs[0])) {
            mexErrMsgIdAndTxt("read_mef_header_mex_3p0:emptyChannelPathArg",
                    "channel_path is empty");
        }
        if (!mxIsChar(prhs[0])) { // if channel_path not char string
            mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidChannelPathArg",
                    "channel_path should be character string");
        }
    }
    
    // set the channel path
    mat_channel_path = mxArrayToString(prhs[0]);
    MEF_strncpy(channel_path, mat_channel_path, MEF_FULL_FILE_NAME_BYTES);
    
    // ***** password *****
    // check input prhs[1]: password (optional)
    if (nrhs > 1) {
        if (!mxIsChar(prhs[1])) { // if password not char string
            mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidPasswordArg",
                    "password should be character string");
        }
        
        // set the password
        mat_password = mxArrayToString(prhs[1]);
        password = strcpy(password_arr, mat_password);
    }
    
    // ***** map indices *****
    // check input prhs[2]: map_indices_flag (optional)
    if (nrhs > 2) {
        if (!mxIsEmpty(prhs[2])) { // if not empty, process
            // check if single numeric or logical
            if ((!mxIsNumeric(prhs[2])
            && !mxIsLogical(prhs[2]))
            || mxGetNumberOfElements(prhs[2]) > 1) {
                mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidMapIndicesArg",
                        "map_indices_flag should be a single value, logical or numeric");
            }
            
            // retrieve the map indices flag value
            mat_map_indices_flag = (si1) mxGetScalar(prhs[2]);
            
            // check the value
            if (mat_map_indices_flag != 0 && mat_map_indices_flag != 1) {
                mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidMapIndicesArg",
                        "map_indices_flag should be 0 (false) or 1 (true)");
            }
            
            // set the flag
            map_indices_flag = mat_map_indices_flag;
        }
    }
    
    // ***** get channel metadata *****
    initialize_meflib(); // initialize MEF library
    
    // read the channel object
    channel = read_MEF_channel( NULL, // allocate new channel object
            channel_path, // channel file path
            TIME_SERIES_CHANNEL_TYPE, // channel type
            password, // password
            NULL, // empty password data
            MEF_FALSE, // do not read time series data
            MEF_FALSE // do not read record data
            );
    
    // error check
    if (channel == NULL) { // nothing read
        mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidChannel",
                "error while reading channel information");
    }
    
    if (channel->channel_type != TIME_SERIES_CHANNEL_TYPE) {
        mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidChannelType",
                "not a time series channel");
    }
    
    // check encryption requirement
    if (channel->metadata.section_1 != NULL) {
        if (channel->metadata.section_1->section_2_encryption > 0
                && channel->metadata.section_1->section_3_encryption > 0) {
            // if the data is still encrypted
            if (password == NULL)
                mexErrMsgIdAndTxt("read_mef_header_mex_3p0:noPassword",
                        "data are encrypted, but no password provided");
            else
                mexErrMsgIdAndTxt("read_mef_header_mex_3p0:invalidPassword",
                        "data are encrypted, but the password is invalid");
        }
    }
    
    // ***** output results *****
    // TODO: this for test, return channel metadata
    if (nlhs > 0) plhs[0] = map_mef3_channel(channel, map_indices_flag);
    
    return;
}


// [EOF]