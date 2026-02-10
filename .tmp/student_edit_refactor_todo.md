# Student Edit Page Refactoring - Task List

## Overview
Separate `student_list_edit_dialog` from `student_list` feature into a standalone `student_edit` page with its own BLoC, following clean architecture principles.

---

## Task Breakdown

### Phase 1: Create Student Edit Page Structure

#### Task 1.1: Create Directory Structure
- **File**: `lib/pages/student_edit/`
- **Description**: Create the page directory with subdirectories
- **Files to create**:
  - `lib/pages/student_edit/bloc/`
  - `lib/pages/student_edit/bloc/state/`
  - `lib/pages/student_edit/view/`
  - `lib/pages/student_edit/widgets/`
- **Dependencies**: None

#### Task 1.2: Create Student Edit State
- **File**: `lib/pages/student_edit/bloc/state/student_edit_state.dart`
- **Description**: Define the state for student edit with freezed
- **Properties needed**:
  - `student: Student` - The student being edited
  - `firstName: TextFieldInput`
  - `lastName: TextFieldInput`
  - `gender: TextFieldInput`
  - `selectedAvatar: String`
  - `studentRequestStatus: RequestStatus`
- **Dependencies**: Task 1.1

#### Task 1.3: Create Student Edit Events
- **File**: `lib/pages/student_edit/bloc/student_edit_event.dart`
- **Description**: Define events for student edit
- **Events needed**:
  - `StudentEditScreenCreated` - Initialize with student data
  - `StudentEditFirstNameChanged`
  - `StudentEditLastNameChanged`
  - `StudentEditGenderChanged`
  - `StudentEditAvatarSelected`
  - `StudentEditSavePressed`
  - `StudentEditErrorTypeCleared`
  - `StudentEditSfxButtonPressed`
- **Dependencies**: Task 1.1

#### Task 1.4: Create Student Edit BLoC
- **File**: `lib/pages/student_edit/bloc/student_edit_bloc.dart`
- **Description**: Implement the business logic for student edit
- **Functionality**:
  - Initialize state with student data on screen creation
  - Handle form field changes with validation
  - Handle avatar selection
  - Handle save operation with API call
  - Emit success/failure states
- **Dependencies**: Task 1.2, Task 1.3

#### Task 1.5: Create BLoC Exports
- **File**: `lib/pages/student_edit/bloc/bloc.dart`
- **Description**: Export bloc files
- **Content**:
  ```dart
  export 'state/student_edit_state.dart';
  export 'student_edit_bloc.dart';
  export 'student_edit_event.dart';
  ```
- **Dependencies**: Task 1.2, Task 1.3, Task 1.4

---

### Phase 2: Create View Layer

#### Task 2.1: Create Student Edit Page
- **File**: `lib/pages/student_edit/view/student_edit_page.dart`
- **Description**: Main page widget that provides BLoC
- **Features**:
  - Accept `Student` as parameter
  - Create and provide `StudentEditBloc`
  - Handle navigation on success
  - Listen for state changes (success/error)
- **Dependencies**: Task 1.5

#### Task 2.2: Create Student Edit Body
- **File**: `lib/pages/student_edit/view/student_edit_body.dart`
- **Description**: The main UI content (converted from dialog)
- **Features** (migrated from dialog):
  - Avatar selection with overlay menu
  - First name input field with validation
  - Last name input field with validation
  - Gender dropdown with validation
  - Save button
  - Cancel button (navigates back)
  - Keyboard shortcuts (Escape, Enter)
- **Dependencies**: Task 2.1

#### Task 2.3: Create View Exports
- **File**: `lib/pages/student_edit/view/view.dart`
- **Description**: Export view files
- **Content**:
  ```dart
  export 'student_edit_page.dart';
  export 'student_edit_body.dart';
  ```
- **Dependencies**: Task 2.1, Task 2.2

#### Task 2.4: Create Widgets Exports
- **File**: `lib/pages/student_edit/widgets/widgets.dart`
- **Description**: Export widgets (if any custom widgets needed)
- **Dependencies**: None (placeholder for future widgets)

---

### Phase 3: Create Page Exports

#### Task 3.1: Create Main Student Edit Export
- **File**: `lib/pages/student_edit/student_edit.dart`
- **Description**: Main export file for the feature
- **Content**:
  ```dart
  export 'bloc/bloc.dart';
  export 'view/view.dart';
  ```
- **Dependencies**: Task 1.5, Task 2.3

---

### Phase 4: Update Routing

#### Task 4.1: Add Student Edit Route
- **File**: `lib/router/router.dart` (or `lib/app_router.dart`)
- **Description**: Add route for student edit page
- **Route**: `/student/edit`
- **Parameters**: Pass `Student` object via extra
- **Example**:
  ```dart
  GoRoute(
    path: '/student/edit',
    builder: (context, state) {
      final student = state.extra as Student;
      return StudentEditPage(student: student);
    },
  ),
  ```
- **Dependencies**: Task 3.1

#### Task 4.2: Add Static Route Constant
- **File**: `lib/pages/student_edit/view/student_edit_page.dart`
- **Description**: Add static route constant to page
- **Content**:
  ```dart
  static const String route = '/student/edit';
  ```
- **Dependencies**: Task 2.1

---

### Phase 5: Update Student List (Remove Dialog)

#### Task 5.1: Update Student List Body Navigation
- **File**: `lib/pages/student_list/view/student_list_body.dart`
- **Description**: Change from dialog to navigation
- **Changes**:
  - Remove `StudentListEditDialog` import
  - Add `StudentEditPage` import
  - Change `showDialog()` to `context.push()`
  - Pass student via extra parameter
- **Dependencies**: Task 4.1

#### Task 5.2: Remove Edit Dialog Events from Student List
- **File**: `lib/pages/student_list/bloc/student_list_event.dart`
- **Description**: Remove events moved to student_edit
- **Events to remove**:
  - `StudentListFirstNameChanged`
  - `StudentListLastNameChanged`
  - `StudentListGenderChanged`
  - `StudentListAvatarSelected`
  - `StudentListEditStudentPressed`
  - `StudentListErrorTypeCleared`
- **Keep** (still used by student_list):
  - `StudentListScreenCreated`
  - `StudentListGameSessionFetched`
  - `StudentListBgmToggled`
  - `StudentListBgmVolumeChanged`
  - `StudentListSfxToggled`
  - `StudentListSfxVolumeChanged`
  - `StudentListSfxButtonPressed`
  - `StudentListDeleteStudentPressed`
- **Dependencies**: None (cleanup)

#### Task 5.3: Remove Edit Dialog State Properties from Student List
- **File**: `lib/pages/student_list/bloc/state/student_list_state.dart`
- **Description**: Remove state properties moved to student_edit
- **Properties to remove**:
  - `firstName: TextFieldInput`
  - `lastName: TextFieldInput`
  - `gender: TextFieldInput`
  - `selectedAvatar: String`
  - `isAvatarMenuOpen: bool`
  - `studentRequestStatus: RequestStatus`
- **Keep** (still used by student_list):
  - `screenRequestStatus`
  - `gameSessionRequestStatus`
  - `students`
  - `gameSessions`
  - `bgmVolume`
  - `sfxVolume`
  - `isBgmMuted`
  - `isSfxMuted`
- **Dependencies**: Task 5.2

#### Task 5.4: Update Student List BLoC
- **File**: `lib/pages/student_list/bloc/student_list_bloc.dart`
- **Description**: Remove edit-related event handlers
- **Remove handlers for**:
  - `StudentListFirstNameChanged`
  - `StudentListLastNameChanged`
  - `StudentListGenderChanged`
  - `StudentListAvatarSelected`
  - `StudentListEditStudentPressed`
  - `StudentListErrorTypeCleared`
- **Keep handlers for**:
  - Screen initialization
  - Game session fetching
  - Audio controls
  - Delete student
- **Dependencies**: Task 5.2, Task 5.3

#### Task 5.5: Delete Student List Edit Dialog
- **File**: `lib/pages/student_list/view/student_list_edit_dialog.dart`
- **Description**: Delete the dialog file (moved to student_edit)
- **Dependencies**: Task 5.1

#### Task 5.6: Update Student List View Exports
- **File**: `lib/pages/student_list/view/view.dart`
- **Description**: Remove edit dialog export
- **Changes**:
  - Remove: `export 'student_list_edit_dialog.dart';`
- **Dependencies**: Task 5.5

---

### Phase 6: Code Generation

#### Task 6.1: Run Freezed Code Generation
- **Command**: `flutter pub run build_runner build --delete-conflicting-outputs`
- **Description**: Generate freezed files for new state
- **Files to generate**:
  - `lib/pages/student_edit/bloc/state/student_edit_state.freezed.dart`
- **Dependencies**: Task 1.2

---

### Phase 7: Testing & Validation

#### Task 7.1: Verify Imports
- **Check**: All imports resolve correctly
- **Files to check**:
  - `lib/pages/student_edit/student_edit.dart`
  - `lib/pages/student_list/view/student_list_body.dart`
  - Router file

#### Task 7.2: Verify Navigation
- **Check**: Edit action navigates to new page
- **Test**: Click edit from student list → Should navigate to student edit page

#### Task 7.3: Verify Form Functionality
- **Check**: All form features work
- **Test scenarios**:
  - Load student data correctly
  - Change avatar
  - Change first name
  - Change last name
  - Change gender
  - Save changes
  - Validation errors
  - Cancel navigation

#### Task 7.4: Verify Student List Still Works
- **Check**: Student list functionality intact
- **Test scenarios**:
  - List loads correctly
  - Delete student works
  - Settings dialog works
  - Audio controls work

---

## Implementation Order (Sequential)

1. **Phase 1**: Create all bloc components (Tasks 1.1-1.5)
2. **Phase 2**: Create view components (Tasks 2.1-2.4)
3. **Phase 3**: Create exports (Task 3.1)
4. **Phase 4**: Add routing (Tasks 4.1-4.2)
5. **Phase 5**: Update student_list to use new page (Tasks 5.1-5.6)
6. **Phase 6**: Run code generation (Task 6.1)
7. **Phase 7**: Test and validate (Tasks 7.1-7.4)

---

## Notes

- The avatar list (19 avatars) should be moved to a shared constants file or kept in the new page
- The validation logic for first name, last name, and gender should be replicated in the new bloc
- The keyboard shortcuts (Escape to close, Enter to save) should be preserved
- Consider extracting the avatar selection widget for reusability
- Make sure to handle the case where student data might be null

## Files to be Created

1. `lib/pages/student_edit/bloc/state/student_edit_state.dart`
2. `lib/pages/student_edit/bloc/student_edit_event.dart`
3. `lib/pages/student_edit/bloc/student_edit_bloc.dart`
4. `lib/pages/student_edit/bloc/bloc.dart`
5. `lib/pages/student_edit/view/student_edit_page.dart`
6. `lib/pages/student_edit/view/student_edit_body.dart`
7. `lib/pages/student_edit/view/view.dart`
8. `lib/pages/student_edit/widgets/widgets.dart`
9. `lib/pages/student_edit/student_edit.dart`

## Files to be Modified

1. `lib/pages/student_list/view/student_list_body.dart`
2. `lib/pages/student_list/bloc/student_list_event.dart`
3. `lib/pages/student_list/bloc/state/student_list_state.dart`
4. `lib/pages/student_list/bloc/student_list_bloc.dart`
5. `lib/pages/student_list/view/view.dart`
6. Router file (path varies)

## Files to be Deleted

1. `lib/pages/student_list/view/student_list_edit_dialog.dart`
