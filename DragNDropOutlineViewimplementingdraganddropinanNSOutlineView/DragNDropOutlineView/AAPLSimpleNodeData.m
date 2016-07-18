/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Represents the model object. Implements NSPasteboardWriting and NSPasteboardReading for easier pasteboard support.
 */

#import "AAPLSimpleNodeData.h"

@interface AAPLSimpleNodeData ()
{
@private
    // ivars for the properties declared below
    NSString *name;
    NSImage *image;
    BOOL expandable;
    BOOL selectable;
    BOOL container;
}

@end


#pragma mark -

@implementation AAPLSimpleNodeData

- (instancetype)init {
    self = [super init];
    if (self != nil)
    {
        self.name = @"Untitled";
        self.expandable = YES;
        self.selectable = YES;
        self.container = YES;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)aName {
    self = [self init];
    self.name = aName;
    return self;
}

+ (AAPLSimpleNodeData *)nodeDataWithName:(NSString *)name {
    return [[AAPLSimpleNodeData alloc] initWithName:name];
}

@synthesize name, image, expandable, selectable, container;

- (NSComparisonResult)compare:(id)anOther {
    // We want the data to be sorted by name, so we compare [self name] to [other name]
    if ([anOther isKindOfClass:[AAPLSimpleNodeData class]]) {
        AAPLSimpleNodeData *other = (AAPLSimpleNodeData *)anOther;
        return [name compare:[other name]];
    } else {
        return NSOrderedAscending;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - '%@' expandable: %d, selectable: %d, container: %d",
            [super description], self.name, self.expandable, self.selectable, self.container];
}


#pragma mark - NSPasteboardWriting support

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    // These are the types we can write.
    NSArray *ourTypes = @[NSPasteboardTypeString];
    // Also include the images on the pasteboard too!
    NSArray *imageTypes = [self.image writableTypesForPasteboard:pasteboard];
    if (imageTypes) {
        ourTypes = [ourTypes arrayByAddingObjectsFromArray:imageTypes];
    }
    return ourTypes;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    if ([type isEqualToString:NSPasteboardTypeString]) {
        return 0;
    }
    // Everything else is delegated to the image
    if ([self.image respondsToSelector:@selector(writingOptionsForType:pasteboard:)]) {            
        return [self.image writingOptionsForType:type pasteboard:pasteboard];
    }
    
    return 0;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if ([type isEqualToString:NSPasteboardTypeString]) {
        return self.name;
    } else {
        return [self.image pasteboardPropertyListForType:type];
    }
}


#pragma mark - NSPasteboardReading support

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    // We allow creation from URLs so Finder items can be dragged to us
    return @[(id)kUTTypeURL, NSPasteboardTypeString];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    if ([type isEqualToString:NSPasteboardTypeString] || UTTypeConformsTo((__bridge CFStringRef)type, kUTTypeURL)) {
	return NSPasteboardReadingAsString;
    } else {
	return NSPasteboardReadingAsData; 
    }
}

- (instancetype)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type {
    // See if an NSURL can be created from this type
    if (UTTypeConformsTo((__bridge CFStringRef)type, kUTTypeURL)) {
        // It does, so create a URL and use that to initialize our properties
        NSURL *url = [[NSURL alloc] initWithPasteboardPropertyList:propertyList ofType:type];
        self = [super init];
        self.name = [url lastPathComponent];
        // Make sure we have a name
        if (self.name == nil) {
            self.name = [url path];
            if (self.name == nil) {
                self.name = @"Untitled";
            }
        }
        self.selectable = YES;
        
        // See if the URL was a container; if so, make us marked as a container too
        NSNumber *value;
        if ([url getResourceValue:&value forKey:NSURLIsDirectoryKey error:NULL] && [value boolValue]) {
            self.container = YES;
            self.expandable = YES;
        } else {
            self.container = NO; 
            self.expandable = NO;
        }

        NSImage *localImage;
        if ([url getResourceValue:&localImage forKey:NSURLEffectiveIconKey error:NULL] && localImage) {
            self.image = localImage;
        }
        
    } else if ([type isEqualToString:NSPasteboardTypeString]) {
        self = [super init];
        self.name = propertyList;
        self.selectable = YES;
    } else {
        NSAssert(NO, @"internal error: type not supported");
    }        
    return self;
}

@end

