//
//  jsc.h
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/5/10.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
JSValue *getJSVinJSC(JSContext *ctx, NSString *key);
void setJSVinJSC(JSContext *ctx, NSString *key, id val);
void setB0JSVinJSC(JSContext *ctx, NSString *key,id(^block)());
void setB1JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id));
void setB2JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id,id));
