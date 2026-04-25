import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color background = Color(0xFFEFF6FF);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color border = Color(0xFFE2E8F0);
  static const Color hover = Color(0xFFEFF6FF);
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 10.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;
}

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Border? border;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        elevation: elevation ?? 2,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.borderRadiusLarge),
        color: backgroundColor ?? AppTheme.cardBackground,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.borderRadiusLarge),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.borderRadiusLarge),
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool fullWidth;
  final bool isLoading;

  const ModernButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    Widget buttonChild = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: _getIconSize()),
            const SizedBox(width: 8),
          ],
          Text(text, style: textStyle),
        ],
      ],
    );

    if (type == ButtonType.outlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          side: BorderSide(color: _getBorderColor()),
          backgroundColor: _getBackgroundColor(),
        ),
        child: buttonChild,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getTextColor(),
        padding: padding,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
      ),
      child: buttonChild,
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.textSecondary,
          foregroundColor: Colors.white,
        );
      case ButtonType.success:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.success,
          foregroundColor: Colors.white,
        );
      case ButtonType.warning:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.warning,
          foregroundColor: Colors.white,
        );
      case ButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.danger,
          foregroundColor: Colors.white,
        );
      case ButtonType.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryBlue,
        );
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.primaryBlue;
      case ButtonType.secondary:
        return AppTheme.textSecondary;
      case ButtonType.success:
        return AppTheme.success;
      case ButtonType.warning:
        return AppTheme.warning;
      case ButtonType.danger:
        return AppTheme.danger;
      case ButtonType.outlined:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ButtonType.outlined:
        return AppTheme.primaryBlue;
      default:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.primaryBlue;
      case ButtonType.secondary:
        return AppTheme.textSecondary;
      case ButtonType.success:
        return AppTheme.success;
      case ButtonType.warning:
        return AppTheme.warning;
      case ButtonType.danger:
        return AppTheme.danger;
      case ButtonType.outlined:
        return AppTheme.primaryBlue;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
      case ButtonSize.medium:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
      case ButtonSize.large:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }
}

enum ButtonType { primary, secondary, success, warning, danger, outlined }
enum ButtonSize { small, medium, large }

class ModernInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool required;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final bool enabled;
  final int? maxLines;

  const ModernInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 2),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.danger),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : AppTheme.hover,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintStyle: const TextStyle(color: AppTheme.textMuted),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppTheme.spacingXSmall),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.danger,
            ),
          ),
        ],
      ],
    );
  }
}

class ModernDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final bool required;
  final bool enabled;

  const ModernDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 2),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            color: enabled ? Colors.white : AppTheme.hover,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(
                hint ?? 'Sélectionner...',
                style: TextStyle(
                  color: enabled ? AppTheme.textMuted : AppTheme.textSecondary,
                ),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: enabled ? AppTheme.primaryBlue : AppTheme.textSecondary,
              ),
              items: items,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}

class ModernBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final BadgeSize size;

  const ModernBadge({
    super.key,
    required this.text,
    this.type = BadgeType.primary,
    this.size = BadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getBadgeColors();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        border: colors.border != null ? Border.all(color: colors.border!) : null,
      ),
      child: Text(
        text,
        style: textStyle.copyWith(color: colors.text),
      ),
    );
  }

  _BadgeColors _getBadgeColors() {
    switch (type) {
      case BadgeType.primary:
        return _BadgeColors(
          background: AppTheme.primaryBlue.withOpacity(0.1),
          text: AppTheme.primaryBlue,
        );
      case BadgeType.success:
        return _BadgeColors(
          background: AppTheme.success.withOpacity(0.1),
          text: AppTheme.success,
        );
      case BadgeType.warning:
        return _BadgeColors(
          background: AppTheme.warning.withOpacity(0.1),
          text: AppTheme.warning,
        );
      case BadgeType.danger:
        return _BadgeColors(
          background: AppTheme.danger.withOpacity(0.1),
          text: AppTheme.danger,
        );
      case BadgeType.secondary:
        return _BadgeColors(
          background: AppTheme.textSecondary.withOpacity(0.1),
          text: AppTheme.textSecondary,
        );
      case BadgeType.outlined:
        return _BadgeColors(
          background: Colors.transparent,
          text: AppTheme.textPrimary,
          border: AppTheme.border,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BadgeSize.small:
        return const TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
      case BadgeSize.medium:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      case BadgeSize.large:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    }
  }
}

class _BadgeColors {
  final Color background;
  final Color text;
  final Color? border;

  _BadgeColors({required this.background, required this.text, this.border});
}

enum BadgeType { primary, success, warning, danger, secondary, outlined }
enum BadgeSize { small, medium, large }

class ModernAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;

  const ModernAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: backgroundColor ?? AppTheme.hover,
      );
    }

    final initials = _getInitials();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlueLight],
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
    return name![0].toUpperCase();
  }
}

class ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const ModernStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor ?? AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ModernInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const ModernInfoBox({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: AppTheme.textMuted),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
