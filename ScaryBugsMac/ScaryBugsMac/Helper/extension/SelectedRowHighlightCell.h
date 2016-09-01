//
//  selectedRowHighlightCell.h
//  ScaryBugsMac
//
//  Created by huoshuguang on 16/8/31.
//  Copyright © 2016年 recomend. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SelectedRowHighlightCell : NSCell
{
    NSColor*                _cellBKColor;
    NSColor*                _cellFontColor;
    NSAttributedString*     _cellAttributedString;
}

- (void)setSelectionBKColor:(NSColor*)cellColor;
- (void)setSelectionFontColor:(NSColor*)cellFontColor;
- (NSAttributedString*)getCellAttributes;
@end
