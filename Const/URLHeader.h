//
//  URLHeader.h
//  NoteBook
//
//

#ifndef URLHeader_h
#define URLHeader_h

#define kHost                   @"http://123.56.76.213/index.php/Home/Index/"
#define kApendAction(action)    [NSString stringWithFormat:@"%@%@",kHost,action]
#define kRegisterUrl            kApendAction(@"register")
#define kLoginUrl               kApendAction(@"login")
#define kResetPwdUrl            kApendAction(@"reset_pwd")
#define kSetHeadImgUrl          kApendAction(@"set_head_img")
#define kSetNicknameUrl         kApendAction(@"set_nick_name")
#define kUploadImageUrl         kApendAction(@"upload_images")
#define kSyncToServerUrl        kApendAction(@"sync_to_server")

#endif /* URLHeader_h */
