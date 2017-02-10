//
//  User.h
//  我的日记本
//
//  Created by 周浩 on 16/12/27.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

kStringProperty(uid)
kStringProperty(userLoginName)
kStringProperty(password)
kStringProperty(userName)
kStrongProperty(UIImage, headImage)

@end
