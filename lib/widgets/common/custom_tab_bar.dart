import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final void Function(int index) onTabChanged;
  final int initialIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color borderColor;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showTrianglePointer;
  final TabController? tabController; // Optional external controller

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
    this.selectedColor = AppColors.primaryGold, // Updated default color
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = AppColors.primaryText, // Updated default color
    this.borderColor = AppColors.borderColor, // Updated default color
    this.height = 50.0,
    this.fontSize = 16.0, // Updated font size
    this.fontWeight = FontWeight.w500,
    this.showTrianglePointer = true,
    this.tabController,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.tabController != null) {
      _tabController = widget.tabController!;
      _isExternalController = true;
    } else {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
    }
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.5, // Make border more prominent
            ),
            borderRadius: BorderRadius.circular(8), // Add border radius
          ),
          child: Row(
            children: List.generate(widget.tabs.length, (index) {
              final isSelected = _tabController.index == index;
              final isFirst = index == 0;
              final isLast = index == widget.tabs.length - 1;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                  },
                  child: Container(
                    height: widget.height - 2,
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : widget.unselectedColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isFirst ? 7 : 0),
                        bottomLeft: Radius.circular(isFirst ? 7 : 0),
                        topRight: Radius.circular(isLast ? 7 : 0),
                        bottomRight: Radius.circular(isLast ? 7 : 0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.tabs[index],
                        style: isSelected 
                            ? AppTextStyles.tabTextActive
                            : AppTextStyles.tabText,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Arrow pointer positioned exactly below the active tab
        if (widget.showTrianglePointer) _buildTrianglePointer(),
      ],
    );
  }

  Widget _buildTrianglePointer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / widget.tabs.length;
        final leftPosition = (_tabController.index * tabWidth) + (tabWidth / 2) - 8;

        return SizedBox(
          width: double.infinity,
          height: 16,
          child: Stack(
            children: [
              Positioned(
                left: leftPosition,
                top: 0,
                child: CustomPaint(
                  painter: TrianglePainter(color: AppColors.primaryGold),
                  size: const Size(16, 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({this.color = AppColors.primaryGold});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Create a more prominent downward pointing triangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
    
    // Add a slight shadow for depth
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
