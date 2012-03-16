# DSGridView
DSGridView is a simple UIKit-based grid view with an interface modelled after UITableView.

## Known Issues
- DSGridViewDelegate protocol is not currently used. Recommend using a UIGestureRecognizer in your data source methods or tile subclass to recognize interactions.
- The grid view is passing the raw NSIndexPath it receives from the table view it owns. This means to get the right tile index, you have to call -[NSIndexPath row]. Will fix soon.

# To Do
- Implement DSGridViewDelegate and add selected states to DSGridViewTile
- More complete interface for table view and table view's protocols.