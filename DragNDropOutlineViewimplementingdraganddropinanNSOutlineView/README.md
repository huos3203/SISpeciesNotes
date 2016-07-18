# DragNDropOutlineView: Implementing Drag and Drop in NSOutlineView

DragNDropOutlineView is a sample application that shows how to implement drag and drop in a NSOutlineView. The application presents some hierarchical data with some fabricated icons. Users are allowed to edit cells, add groups and leafs, and can drag any of the rows around to reorder elements of the outline view. New items can be added by dragging from Finder. This sample code demonstrates:

• Drag and drop in an NSOutlineView, including drop on and between items.
• How to re-target the location of a drop in an outline view.
• Display and editing of custom and standard cells in an outline view.
• How to reload parts of an outline view when the data source's model changes.
• Other simple outline view features (e.g.. cell editing, handling single click actions, etc...)

## Requirements

### Build

Xcode 6.0 or later; OS X 10.10 SDK or later

### Runtime

OS X 10.8 or later


## Sources

AppController.m

The AppController object acts as the outline view's delegate and data source. It maintains a tree like structure as its model which, is initially loaded from an input file. The nodes of the this structure are SimpleTreeNodes, each having a pointer to some SimpleTreeData. Items in the outlineView are SimpleTreeNode objects. Given a particular SimpleTreeNode, the AppController can access the data part and determine is the item is expandable, a leaf, etc.   

To allow drags to be initiated from the outline view, the AppController does some simple work. When a user clicks and drags horizontally (or vertically if setVerticalMotionCanBeginDrag:YES has been sent to outlineView), it is sent the delegate method outlineView:pasteboardWriterForItem for each dragged item. In this method, the model object is returned. The model object (SimpleNodeData) implements NSPasteboardWriting to support writing items to the pasteboard. That is enough to support begin a dragging source. However, to support reordering, outlineView:draggingSession:willBeginAtPoint:forItems: is implemented to keep track of which items are being dragged. In addition, a special pasteboard type is placed on the pasteboard to identify this drag for reordering.

In order to be the recipient of drags, the AppController registers the outlineView for a few simple drag types, including a custom drag type used to identify which rows are being dragged. When a drag with appropriate paste board types hovers over the outline view, the AppController will be sent the method outlineView:validateDrop:proposedItem:proposedChildIndex:. In this method, the AppController determines if the proposed drop location (determined by parent, and child index) is valid. To demonstrate retargeting, the AppController simply retargets the drop to the entire outline view when the "Only Allowed To Drop On Root" check is set.

To support multiple item drags in Lion, outlineView:updateDraggingItemsForDrag: is used to update the drag images from the dragging info. This is done by creating temporary model objects based on the pasteboard items using enumerateDraggingItemsWithOptions:forView:classes:searchOptions:usingBlock:.  In outlineView:acceptDrop:item:childIndex: new model items are created by SimpleNodeData implementing NSPasteboardReading and inserted into the model. In addition, NSDraggingItem's have their final draggingFrame set so the drop images animate into their final drop target location.

The AppController also demonstrates how to allow check box button cells in a table view to not change the selection when clicked. Review the code for outlineView:shouldSelectItem: and outlineView:shouldTrackCell:forTableColumn:item: for more information.

ImageAndTextCell.m

The cell class used for display in our outline view. ImageAndTextCell is a subclass of NSTextFieldCell that can display images and text at the same time. The implementation is pretty simple, and mostly involves accounting for the size of the image when displaying (in drawWithFrame:inView:) and editing the cell (in editWithFrame:inView:editor:delegate:event:). In addition, it properly implements titleRectForBounds: in order for expansion tool tips to automatically work in a table or outline view.

SimpleNodeData.m

This represents the model object and implement both NSPasteboardReading and NSPasteboardWriting. The model objects are wrapped in standard NSTreeNode instances and passed to the NSOutlineView.


Copyright (C) 2009-2014 Apple Inc. All rights reserved.
