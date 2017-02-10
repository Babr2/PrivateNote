//
//  HUDHeader.h
//  NoteBook
//
//  Created by 风过的夏 on 16/9/10.
//  Copyright © 2016年 风过的夏. All rights reserved.
//

#ifndef HUDHeader_h
#define HUDHeader_h

#define HUDShow(x) \
dispatch_async(dispatch_get_main_queue(), ^{ \
    [ProgressHUD show:NSLocalizedString(x, nil)]; \
});

#define HUDShowLoading \
dispatch_async(dispatch_get_main_queue(), ^{ \
     [ProgressHUD show:NSLocalizedString(@"Loading...", nil)]; \
});

#define HUDSuccess(x) \
dispatch_async(dispatch_get_main_queue(), ^{ \
    [ProgressHUD showSuccess:NSLocalizedString(x, nil)]; \
});

#define HUDError(x) \
dispatch_async(dispatch_get_main_queue(), ^{ \
    [ProgressHUD showError:NSLocalizedString(x, nil)]; \
});

#define HUDDismiss \
dispatch_async(dispatch_get_main_queue(), ^{ \
    [ProgressHUD dismiss]; \
});

#endif /* HUDHeader_h */
