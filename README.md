# FreightPro — Bug Fixes

Drop each file into the matching path in your project. Every fix is annotated 
with a `// FIX:` comment explaining what changed and why.

## Files Changed & What Was Fixed

| File | Fixes Applied |
|------|--------------|
| `lib/main.dart` | Removed deprecated `ColorScheme.background`; replaced `MaterialStateProperty` → `WidgetStateProperty` |
| `lib/core/services/session_service.dart` | `clear()` now removes only this app's keys instead of wiping all SharedPreferences |
| `lib/features/auth/services/auth_service.dart` | Server errors (500, 503, 404) no longer shown as "Invalid credentials" |
| `lib/features/shipment_groups/models/shipment_group_model.dart` | Added `isUnknown` guard; `debugPrint` wrapped in `kDebugMode` |
| `lib/features/shipment_groups/providers/shipment_groups_provider.dart` | Default team aligned to `'inbound'` (was contradicting SessionService); unknown-type groups no longer silently dropped; `debugPrint` guarded |
| `lib/features/shipment_groups/services/shipment_group_service.dart` | All `debugPrint` calls guarded by `kDebugMode` |
| `lib/features/shipment_groups/screens/shipment_groups_screen.dart` | **Critical:** Fixed `\$otherTeam` escaped string (was displaying literal `$otherTeam`); search clear button now uses `ValueListenableBuilder`; `withOpacity()` → `withValues(alpha:)` |
| `lib/features/shipment_groups/screens/shipment_group_detail_screen.dart` | Error logging in `_pick()`; `withOpacity()` → `withValues(alpha:)` throughout |
| `lib/features/documents/services/document_service.dart` | `jpg` → `image/jpeg` MIME fix; unique XID with index suffix; errors now logged; non-2xx responses logged |
| `pubspec.yaml` | Removed non-existent `assets/` declaration |

## How to Apply

1. Copy the files from this folder into your project, replacing the originals.
2. Run `flutter pub get` after replacing `pubspec.yaml`.
3. Run `flutter analyze` — should return zero issues.

## Notes

- All `withOpacity()` calls have been replaced with `withValues(alpha:)` 
  which is the correct API for Flutter 3.27+.
- If you are on Flutter < 3.27, `withOpacity()` still works — but updating 
  is recommended.
- If you later add real asset files, re-add the `assets:` section to `pubspec.yaml`.
