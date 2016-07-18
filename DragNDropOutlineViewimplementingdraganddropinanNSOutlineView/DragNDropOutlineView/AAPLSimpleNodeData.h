/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Represents the model object. Implements NSPasteboardWriting and NSPasteboardReading for easier pasteboard support.
 */

@import Foundation;
@import Cocoa;

@interface AAPLSimpleNodeData : NSObject<NSPasteboardWriting, NSPasteboardReading>

- (instancetype)initWithName:(NSString *)name;
+ (AAPLSimpleNodeData *)nodeDataWithName:(NSString *)name;

@property(readwrite, copy) NSString *name;
@property(readwrite, strong) NSImage *image;
@property(readwrite, getter=isContainer) BOOL container;
@property(readwrite, getter=isExpandable) BOOL expandable;
@property(readwrite, getter=isSelectable) BOOL selectable;

@end

