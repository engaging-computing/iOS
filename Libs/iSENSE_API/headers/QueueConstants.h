/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// QueueConstants.h
// iSENSE_API
//
// Created by Michael Stowell on 9/6/13.
//

#ifndef Data_Walk_QueueConstants_h
#define Data_Walk_QueueConstants_h

// constants for QueueUploaderView's actionSheet
#define QUEUE_RENAME             0
#define QUEUE_CHANGE_DESC        1
#define QUEUE_SELECT_PROJ        2

#define QUEUE_LOGIN              500
#define QUEUE_SELECT_USER_OR_KEY 501
#define QUEUE_CONTRIB_KEY        502

// options for menu and action sheet
#define OPTION_CANCELED              0
#define OPTION_ENTER_PROJECT         1
#define OPTION_BROWSE_PROJECTS       2
#define OPTION_SCAN_PROJECT_QR       3
#define OPTION_PROJECT_MANUAL_ENTRY  4
#define OPTION_APPLY_PROJ_AND_FIELDS 5

// other character restriction text field tags
#define TAG_QUEUE_RENAME    700
#define TAG_QUEUE_DESC      701
#define TAG_QUEUE_PROJ      702
#define TAG_STEPONE_PROJ    703
#define TAG_AUTO_LOGIN      704
#define TAG_MANUAL_LOGIN    705
#define TAG_MANUAL_PROJ     706

// indices for contributor key and login in the selection dialog
#define INDEX_CONTRIB_KEY 1
#define INDEX_LOGIN       2

#endif
