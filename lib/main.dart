import 'package:flutter/material.dart';

void main() {
  runApp(const InnovationHelloApp());
}

class InnovationHelloApp extends StatelessWidget {
  const InnovationHelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '刘子轩的创新实验',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const HelloHomePage(),
    );
  }
}

class HelloHomePage extends StatefulWidget {
  const HelloHomePage({super.key});

  @override
  State<HelloHomePage> createState() => _HelloHomePageState();
}

class _HelloHomePageState extends State<HelloHomePage>
    with TickerProviderStateMixin {
  int completedTasks = 0;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void finishOneTask() {
    _bounceController.forward(from: 0);
    setState(() {
      completedTasks += 1;
    });
  }

  String get _motivationText {
    if (completedTasks == 0) return '点击下方按钮开始打卡吧！';
    if (completedTasks < 3) return '不错的开始，继续加油！';
    if (completedTasks < 5) return '已经进入状态了 💪';
    if (completedTasks < 10) return '太厉害了，效率爆表！🔥';
    return '传说级学霸，无人能挡！🏆';
  }

  IconData get _levelIcon {
    if (completedTasks < 3) return Icons.sentiment_satisfied;
    if (completedTasks < 5) return Icons.sentiment_very_satisfied;
    if (completedTasks < 10) return Icons.local_fire_department;
    return Icons.emoji_events;
  }

  Color get _levelColor {
    if (completedTasks < 3) return Colors.blue;
    if (completedTasks < 5) return Colors.green;
    if (completedTasks < 10) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.surface,
              colorScheme.secondaryContainer.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // === 顶部标题 ===
                  Text(
                    '刘子轩的 Flutter 个人主页',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '创新实验第14周 · Flutter Hello World',
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // === 头像区域（带脉冲动画） ===
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colorScheme.primary, colorScheme.tertiary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 52, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === 个人信息卡片 ===
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _infoChip(Icons.badge, '刘子轩'),
                              const SizedBox(width: 12),
                              _infoChip(Icons.numbers, '学号 0427'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _infoChip(Icons.school, '创新实验'),
                              const SizedBox(width: 12),
                              _infoChip(Icons.calendar_today, '第14周'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === 打卡计数卡片（带动画） ===
                  ScaleTransition(
                    scale: _bounceAnimation,
                    child: Card(
                      color: colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(_levelIcon, size: 32, color: _levelColor),
                                const SizedBox(width: 12),
                                Text(
                                  '$completedTasks',
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w900,
                                    color: colorScheme.primary,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '次',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '今日打卡',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // === 激励语 ===
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _motivationText,
                      key: ValueKey<String>(_motivationText),
                      style: TextStyle(
                        fontSize: 16,
                        color: _levelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === 进度条 ===
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '今日进度',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                '${(completedTasks / 10 * 100).round().clamp(0, 100)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (completedTasks / 10).clamp(0.0, 1.0),
                              minHeight: 10,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _levelColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '目标：10次打卡',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // === 打卡按钮 ===
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: finishOneTask,
                      icon: const Icon(Icons.add_task_rounded, size: 22),
                      label: const Text(
                        '完成一次打卡',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // === 重置按钮 ===
                  if (completedTasks > 0)
                    TextButton.icon(
                      onPressed: () {
                        setState(() { completedTasks = 0; });
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('重置计数'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
