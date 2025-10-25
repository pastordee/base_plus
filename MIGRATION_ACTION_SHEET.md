# ActionSheet Migration Guide

## Summary of Changes

The action sheet implementation has been unified to use **native platform channels** for the best iOS experience. The naming has been simplified:

- ✅ **`BaseActionSheet`** - Now the main native implementation (previously `BaseCNActionSheet`)
- ✅ **`CNActionSheetAction`** - Action data class (CN = Cupertino Native)
- ✅ **`CNActionSheetButtonStyle`** - Style enum for actions
- ⚠️ **`BaseCNActionSheet`** - Now deprecated, use `BaseActionSheet` instead
- ⚠️ **`BaseActionSheetWidget`** - Old widget-based implementation (deprecated)
- ⚠️ **`BaseActionSheetAction`** - Old widget-based action (deprecated)

## Why This Change?

The codebase had **two competing implementations**:
1. **Widget-based** (`BaseActionSheet` + `BaseActionSheetAction`) - Pure Flutter implementation
2. **Native-based** (`BaseCNActionSheet` + `CNActionSheetAction`) - True native iOS via platform channels

We've unified on the **native approach** because:
- ✅ True native iOS experience
- ✅ Better platform integration
- ✅ Simpler API (static methods vs widget instances)
- ✅ Follows Apple HIG guidelines more closely

## Migration Examples

### Old Code (BaseCNActionSheet)
```dart
await BaseCNActionSheet.show(
  context: context,
  title: 'Delete Draft?',
  message: 'This action cannot be undone.',
  actions: [
    CNActionSheetAction(
      title: 'Delete Draft',
      style: CNActionSheetButtonStyle.destructive,
      onPressed: () => deleteDraft(),
    ),
  ],
  cancelAction: CNActionSheetAction(
    title: 'Cancel',
    style: CNActionSheetButtonStyle.cancel,
  ),
);
```

### New Code (BaseActionSheet)
```dart
// Exactly the same! Just rename BaseCNActionSheet → BaseActionSheet
await BaseActionSheet.show(
  context: context,
  title: 'Delete Draft?',
  message: 'This action cannot be undone.',
  actions: [
    CNActionSheetAction(
      title: 'Delete Draft',
      style: CNActionSheetButtonStyle.destructive,
      onPressed: () => deleteDraft(),
    ),
  ],
  cancelAction: CNActionSheetAction(
    title: 'Cancel',
    style: CNActionSheetButtonStyle.cancel,
  ),
);
```

### Old Widget-Based Code (Deprecated)
```dart
BaseActionSheet(
  title: Text('Title'),
  message: Text('Message'),
  actions: [
    BaseActionSheetAction(
      child: Text('Delete'),
      isDestructiveAction: true,
      onPressed: () {
        Navigator.of(context).pop();
        deleteItem();
      },
    ),
  ],
  cancelButton: BaseActionSheetAction(
    child: Text('Cancel'),
    onPressed: () => Navigator.of(context).pop(),
  ),
).show<void>(context);
```

### Migrating Widget-Based to Native
```dart
// Convert to native approach
BaseActionSheet.show(
  context: context,
  title: 'Title',
  message: 'Message',
  actions: [
    CNActionSheetAction(
      title: 'Delete',
      style: CNActionSheetButtonStyle.destructive,
      onPressed: () => deleteItem(),
    ),
  ],
  cancelAction: CNActionSheetAction(
    title: 'Cancel',
    style: CNActionSheetButtonStyle.cancel,
  ),
);
```

## Key API Differences

| Feature | Native (BaseActionSheet) | Widget (Deprecated) |
|---------|-------------------------|---------------------|
| **API Style** | Static methods | Widget instance |
| **Title/Message** | String | Widget |
| **Actions** | `CNActionSheetAction` data class | `BaseActionSheetAction` widget |
| **Styling** | `CNActionSheetButtonStyle` enum | `isDestructiveAction`, `isDefaultAction` bools |
| **Return** | `Future<int?>` (index) | `Future<T?>` (generic) |
| **Auto-dismiss** | ✅ Yes | ❌ Manual `Navigator.pop()` |

## Platform Behavior

### iOS
- Uses **native iOS action sheets** via platform channels
- True UIAlertController implementation
- Follows iOS design guidelines
- Native animations and haptics

### Android/Other Platforms
- Fallback to **Material Design bottom sheet**
- Styled to match Material 3 guidelines
- Consistent API across platforms

## Common Patterns

### Simple Confirmation
```dart
final confirmed = await BaseActionSheet.showConfirmation(
  context: context,
  title: 'Delete Item?',
  message: 'This cannot be undone.',
  confirmTitle: 'Delete',
  cancelTitle: 'Cancel',
  onConfirm: () => deleteItem(),
);

if (confirmed) {
  // Item was deleted
}
```

### Multiple Options
```dart
final result = await BaseActionSheet.show(
  context: context,
  title: 'Share Document',
  actions: [
    CNActionSheetAction(
      title: 'Email',
      onPressed: () => shareViaEmail(),
    ),
    CNActionSheetAction(
      title: 'Messages',
      onPressed: () => shareViaMessages(),
    ),
    CNActionSheetAction(
      title: 'AirDrop',
      onPressed: () => shareViaAirDrop(),
    ),
  ],
  cancelAction: CNActionSheetAction(title: 'Cancel'),
);
```

### Destructive Action
```dart
await BaseActionSheet.show(
  context: context,
  title: 'Remove Friend',
  message: 'You will no longer see their posts.',
  actions: [
    CNActionSheetAction(
      title: 'Remove Friend',
      style: CNActionSheetButtonStyle.destructive,
      onPressed: () => removeFriend(),
    ),
  ],
  cancelAction: CNActionSheetAction(title: 'Cancel'),
);
```

## Breaking Changes

### None for most users!
If you were using `BaseCNActionSheet`, you only need to rename it to `BaseActionSheet`. The API is identical.

### For widget-based users
If you were using the old widget-based `BaseActionSheet`:
1. Convert title/message from `Widget` to `String`
2. Replace `BaseActionSheetAction` widgets with `CNActionSheetAction` data classes
3. Change from `.show()` method to static `BaseActionSheet.show()`
4. Remove manual `Navigator.pop()` calls (handled automatically)
5. Change `isDestructiveAction` → `CNActionSheetButtonStyle.destructive`
6. Change `isDefaultAction` → `CNActionSheetButtonStyle.defaultStyle`

## Timeline

- **Current (3.0.5)**: Both implementations available, deprecation warnings added
- **Next Minor (3.1.0)**: Widget-based implementation still available but deprecated
- **Future Major (4.0.0)**: Widget-based implementation will be removed

## Questions?

- Native implementation uses the `cupertino_native` package
- For iOS, requires platform channel setup
- Material fallback works on all platforms without additional setup
- See examples in `/flutter_base_ex/lib/demos/action_sheet/`
