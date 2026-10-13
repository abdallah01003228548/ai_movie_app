import 'dart:typed_data';

import 'package:ai_movie_app/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:ai_movie_app/profile/presentation/cubit/edit_profile_state.dart';
import 'package:ai_movie_app/profile/presentation/cubit/profile_cubit.dart';
import 'package:ai_movie_app/profile/presentation/cubit/profile_state.dart';
import 'package:ai_movie_app/profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      _nameController.text = state.data.fullName ?? '';
      _emailController.text = state.data.email;
      _passwordController.text = '********'; // Masked, read-only
      _phoneController.text = state.data.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ── Avatar bottom sheet ───────────────────────────────────────────────────

  void _showPhotoOptions(BuildContext context, bool hasPhoto) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF252836),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _sheetOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Choose from gallery',
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    context
                        .read<EditProfileCubit>()
                        .pickPhoto(ImageSource.gallery);
                  },
                ),
                _sheetOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Take a photo',
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    context
                        .read<EditProfileCubit>()
                        .pickPhoto(ImageSource.camera);
                  },
                ),
                if (hasPhoto)
                  _sheetOption(
                    icon: Icons.delete_outline,
                    label: 'Remove photo',
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      context.read<EditProfileCubit>().markRemovePhoto();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final effectiveColor = color ?? Colors.white;
    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(label, style: TextStyle(color: effectiveColor, fontSize: 16)),
      onTap: onTap,
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  void _save(EditProfileState editState) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Uint8List? pendingBytes;
    bool removePhoto = false;

    if (editState is EditProfileIdle) {
      pendingBytes = editState.pendingPhotoBytes;
      removePhoto = editState.pendingRemovePhoto;
    }

    context.read<EditProfileCubit>().saveChanges(
          fullName: name,
          phoneNumber: _phoneController.text.trim(),
          pendingPhotoBytes: pendingBytes,
          removePhoto: removePhoto,
        );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, editState) {
        if (editState is EditProfileSaved) {
          Navigator.pop(context);
        } else if (editState is EditProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(editState.message)),
          );
          // Reset to idle so the user can try again
          context.read<EditProfileCubit>().clearPendingPhoto();
        }
      },
      builder: (context, editState) {
        final isSaving = editState is EditProfileSaving;

        // Determine what photo to show and whether "Remove photo" is relevant
        Uint8List? previewBytes;
        bool hasPendingRemove = false;
        bool hasPendingPhoto = false;

        if (editState is EditProfileIdle) {
          previewBytes = editState.pendingPhotoBytes;
          hasPendingRemove = editState.pendingRemovePhoto;
          hasPendingPhoto = previewBytes != null;
        }

        // When user marked remove, show placeholder (no bytes)
        final avatarOverride = hasPendingRemove ? null : previewBytes;

        // "Remove photo" option is shown when:
        //  - there's a pending new photo, OR
        //  - there's currently a saved photo and the user hasn't already marked remove
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            String? displayName;
            String? displayEmail;
            bool hasSavedPhoto = false;

            if (profileState is ProfileLoaded) {
              displayName = profileState.data.fullName ?? profileState.data.email.split('@').first;
              displayEmail = profileState.data.email;
              hasSavedPhoto = profileState.data.photoBytes != null;
            }

            final showRemoveOption =
                hasPendingPhoto || (hasSavedPhoto && !hasPendingRemove);

            return Scaffold(
              backgroundColor: const Color(0xFF1F1D2B),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Avatar block (Figma "Edit Profile" frame) ──────────
                    Center(
                      child: Column(
                        children: [
                          // When hasPendingRemove, pass overrideBytes=null so
                          // we show placeholder; otherwise pass the preview.
                          hasPendingRemove
                              ? ProfileAvatar(
                                  radius: 44,
                                  overrideBytes: null,
                                  onEditTap: () => _showPhotoOptions(
                                    context,
                                    showRemoveOption,
                                  ),
                                )
                              : ProfileAvatar(
                                  radius: 44,
                                  overrideBytes: avatarOverride,
                                  onEditTap: () => _showPhotoOptions(
                                    context,
                                    showRemoveOption,
                                  ),
                                ),
                          const SizedBox(height: 12),
                          if (displayName != null)
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (displayEmail != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              displayEmail,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Text fields ────────────────────────────────────────
                    _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      enabled: false,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Password',
                      controller: _passwordController,
                      enabled: false,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 48),

                    // ── Save button ────────────────────────────────────────
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              if (_nameController.text.trim().isNotEmpty) {
                                _save(editState);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00C9E0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white54,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF252836),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
